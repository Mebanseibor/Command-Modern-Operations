--[[
    ONLY WORKS FOR SCENARIO EDITOR (For now)
    
    Development Notes:
        Deployment Condition:
            -Escorters deploy only when Aircraft is ready or airborne
            -Escortee deploys when Escort Aircrafts are ready
        Tips:
            -Create task pool for Escorters Plane:
        Future Enhancements:
            -Ability to ignore readiness of Escorters
            -Throttel adjustment
            -Altitude adjustment
            -Investigate Unknown Contacts within a Certain Range
            -If Escortee is destroyed, delete RP
            -Change Escorter's Winchester condition (No withdraw when Ammunition is still available)
            -Change Doctrine (Winchester and Bingo Conditions)
            -What if Escortee lands?
            -How to take guid of units in base?
            -Add Event that alerts of any notable contacts within procecution area
            -Ocassionally update the PatrolArea Waypoint of the escorters to point near the escortee
                local _referencepoint = objRP
                local _unit = objUnit
                
                local _wp = _unit.course[1].WayPoint
                _wp.latitude = rp.latitude
                _wp.longitude = rp.longitude
                print(_wp)
                ScenEdit_SetUnit({guid=_unit.guid, course=_course})
            -Out of Comms unit still retains its RP point, which tracks the actual unit
            -Add Button for easier integration
            -Add ability to assign RP to the unit by selecting the unit, rather than supplying its Guid
            -How to handle Lone Escortee when escorters are refueling?
            -If Zone Violators are detected, send more Escortees from base:
                -Decreasing the "Try to keep n units per-class on station"
            -Ability to add the mission as a package to a Task Pool
            -Add Targetting Priority to:
                -Fighters
                -Multirole Aircrafts
                -UCAV
                -Attack Aircrafts
                -Any Aircrafts
                -Guided Weapons
        
    Instruction to use:
            -Select the Escortee (Aircraft that will be escorted)
            -Run script
            Note: A New Patrol Mission will be created by the name "Escort Mission for..."
                -Assign Escorters (Aircraft that will escort the escortee) to the mission
                -IMPORTANT: Change the "Number of a/c to investigate unknown contacts" to "None"
                -Add Prosecution Zone
                    -Prosecution Zone would basically serve as the area that the escorters will engage hostile contacts
                -Set Attack Distance (Ideal: 0.8x Prosecution Zone 'radius')
                -Adjust Throttle speed of the escortee (Escorted aircraft) to match the speed of your more speedy fighters/multirole aircrafts
                -(Optional) Adjust flights size to your need
                -(Optional) Adjust number of aircrafts to engage hostiles to your need
                    Warning: Setting it to "All Flights" will cause all escorters to chase one Hostile, which leaves the escortee vulnerable to being attack from other contacts approaching from the opposite direction
]]--


local _table = {name='A-50E/I Mainstay', guid='9V0YME-0HN357898CTA9'}    --<-----Replace table with Copied Unit Data here


-----GENERAL UTILITY FUNCTIONS-----
local function is_boolean(data)return type(data)=="boolean" end
local function is_not_boolean(data)return type(data)~="boolean" end
local function is_number(data)return type(data)=="number" end
local function is_not_number(data)return type(data)~="number" end
local function is_table(data)return type(data)=="table" end
local function is_not_table(data)return type(data)~="table" end
local function is_string(data)return type(data)=="string" end
local function is_not_string(data)return type(data)~="string" end
local function is_nil(data)return type(data)=="nil" end
local function is_not_nil(data)return type(data)~="nil" end

local function is_empty(data)
    if is_nil(data) or (is_not_boolean(data) and is_not_number(data)) then
        if is_nil(data) then return true end --for nil values
        if is_table(data) then          --for tables
            for k,v in pairs(data) do
                return false
            end
            return true
        elseif data =="" then           --for strings
            return true
        else
            return false
        end
    else return false end
end

--<<Tables>>--
local function table_has_element(_table,_element)
    -- Error Handling
    if is_not_table(_table) then
        error("Invalid Parameter #1: Expected a table",2)
    elseif is_empty(_element) then
        error("Invalid Parameter #2: Expected a value",2)
    end
    if is_empty(_table) then
        return false
    end
    for k,v in pairs (_table) do
        if v==_element then
            return true
        end
    end
    return false
end

local function table_length(_table)
    if is_nil(_table) then
        return 0
    end
    if is_not_table(_table) then
        error("Invalid Parameter: Expected a table", 2)
    end
    local count=0
    for i in pairs(_table) do
        count=count+1
    end
    return count
end
------------------------------




local function CMOT_Escort_Trailing_RP(escortee)
    local _table = {}
    _table.bearing = (escortee.heading+180) % 360
    _table.bearingtype = "Rotating"
    _table.color = "cyan"
    _table.distance = 0.2
    _table.name = escortee.name.." Escort RP"
    _table.relativeto = escortee.guid
    _table.side = ScenEdit_PlayerSide()
    
    local rp = ScenEdit_AddReferencePoint(_table)

    local _info = {}
    _info.name = escortee.name
    _info.guid = escortee.guid
    _info.rp = rp.guid
    _info.mission = ""
    
    table.insert(CMOT_Escort_Escorts, _info)
    return rp
end

local function CMOT_Escort_Patrol_Mission(escortee, rp)
    local _table = {}
    _table.type = "AAW"
    _table.zone = {rp.guid}
    CMOT_Escort_Escorts[#CMOT_Escort_Escorts].mission = (ScenEdit_AddMission(ScenEdit_PlayerSide(), "Escort Mission for "..escortee.name, "Patrol", _table)).guid
    
    local _table={}
    _table.OneThirdRule = false
    _table.UseFlightSize = false
    _table.CheckOPA = true   -- can investigate outside zones
    _table.CheckWWR = false  -- can investigate within weapon range
    --_table["FlightsToInvestigate"] = "None"
    --_table[""] = --"Try to keep 2 per class on station"--
    --_table["ProsecutionZone"] = {}    --table of reference points for Prosecution Zone
    ScenEdit_SetMission(ScenEdit_PlayerSide(), CMOT_Escort_Escorts[#CMOT_Escort_Escorts].mission,_table)

    local _table={}
    _table.fuel_state_rtb = 3   -- 3 = YesLeaveGroup
    _table.weapon_state_planned = 2002
        -- 2002 = Winchester_ToO (Same as above, but engage nearby bogies with guns after we're out of missiles.
        -- Applies to air-to-air missile loadouts only.
        -- For guns-only air-to-air loadouts and all air-to-ground loadouts the behaviour is the same as above.
        -- PREFERRED OPTION!
    _table.weapon_state_rtb = 3  -- 3 = YesLeaveGroup
    _table.engage_opportunity_targets = false    -- Don't engage non-mission contacts
    _table.engaging_ambiguous_targets = 1        -- optimistic
    
    --Optional:
    --<Doctrine>:addTargetPriorityEntry(type, subtype, isfixedfacilitysubtype, dbid, index)

    ScenEdit_SetDoctrine({side=ScenEdit_PlayerSide(), mission=CMOT_Escort_Escorts[#CMOT_Escort_Escorts].mission},_table)
end


local function CMOT_Escort_ProsecutionZone(rp, _radius)
    --_table["ProsecutionZone"] = 
    local rp = ScenEdit_GetReferencePoint({side=ScenEdit_PlayerSide(), name=CMOT_Escort_Escorts[#CMOT_Escort_Escorts].rp})
    local points = World_GetCircleFromPoint ({latitude = rp.latitude, longitude = rp.longitude, numpoints = 12, radius = _radius })
    print(points)
end



-----*****CONTROLLERS*****-----
local function CMOT_Escort_Init(escortee, _radius)
    --Check if a RP Point for the escortee already exist
    for k,_escort in pairs(CMOT_Escort_Escorts) do
        if _escort.guid == escortee.guid then
            return
        end
    end
    local rp = CMOT_Escort_Trailing_RP(escortee)
    CMOT_Escort_Patrol_Mission(escortee, rp)
    --CMOT_Escort_ProsecutionZone(rp, _radius)
end

local function CMOT_Escort_Clear()
    --Checks if "CMOT_Escort_Escorts" exist
    if is_not_nil(CMOT_Escort_Escorts) then
        for k, escort in pairs(CMOT_Escort_Escorts) do
            ScenEdit_DeleteReferencePoint({side = ScenEdit_PlayerSide(), guid = escort.rp})
            ScenEdit_DeleteMission(ScenEdit_PlayerSide(), escort.mission)
        end
        CMOT_Escort_Escorts={}
    end
end
--------------------------------




if is_nil(CMOT_Escort_Escorts) and is_not_table(CMOT_Escort_Escorts) then
    CMOT_Escort_Escorts = {}
    print(CMOT_Escort_Escorts)
end

local escortee = ScenEdit_GetUnit(_table)
local _side_name = ScenEdit_PlayerSide()

print(CMOT_Escort_Escorts)
CMOT_Escort_Init(escortee, 50)  --50 indicates radius of ProsecutionZone (Feature Not Implemented Yet)
print(CMOT_Escort_Escorts)
--CMOT_Escort_Clear()