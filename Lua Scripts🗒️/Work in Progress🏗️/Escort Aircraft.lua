--[[
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
            -Change the "Number of a/c to investigate unknown contacts" to "None"
            -Add Prosecution Zone
                -Prosecution Zone would indicate the max range that escorts may venture out
            -Set Attack Distance (Ideal: 1.5x Prosecution Zone radius)
            -Adjust Throttle speed
            -Adjust flights size to your need
            -Adjust number of aircrafts to engage hostiles
]]--



local function CMOT_Escort_Trailing_RP(escortee)
    local _table = {}
    _table ["bearing"] = (escortee.heading+180) % 360
    _table ["bearingtype"] = "Rotating"
    _table ["color"] = "cyan"
    _table ["distance"] = 0.2
    _table ["name"] = escortee.name.." Escort RP"
    _table ["relativeto"] = escortee.guid
    _table ["side"] = ScenEdit_PlayerSide()
    
    local rp = ScenEdit_AddReferencePoint(_table)

    local _info = {}
    _info["name"] = escortee.name
    _info["guid"] = escortee.guid
    _info["rp"] = rp.guid
    _info["mission"]=""
    
    table.insert(CMOT_Escort_Escorts, _info)

    return rp
end

local function CMOT_Escort_Patrol_Mission(escortee, rp)
    local _table = {}
    _table["type"] = "AAW"
    _table["zone"] = {rp.guid}
    CMOT_Escort_Escorts[#CMOT_Escort_Escorts]["mission"] = (ScenEdit_AddMission(ScenEdit_PlayerSide(), "Escort Mission for "..escortee.name, "Patrol", _table)).guid
    
    local _table={}
    _table["OneThirdRule"] = false
    _table["UseFlightSize"] = false
    _table["CheckOPA"] = true   -- can investigate outside zones
    _table["CheckWWR"] = false  -- can investigate within weapon range
    --_table["FlightsToInvestigate"] = "None"
    --_table[""] = --"Try to keep 2 per class on station"--
    --_table["ProsecutionZone"] = {}    --table of reference points for Prosecution Zone
    ScenEdit_SetMission(ScenEdit_PlayerSide(), CMOT_Escort_Escorts[#CMOT_Escort_Escorts].mission,_table)

    local _table={}
    _table["fuel_state_rtb"] = 3   -- 3 = YesLeaveGroup
    _table["weapon_state_planned"] = 2002
    --[[
        2002 = Winchester_ToO (Same as above, but engage nearby bogies with guns after we're out of missiles.
        Applies to air-to-air missile loadouts only.
        For guns-only air-to-air loadouts and all air-to-ground loadouts the behaviour is the same as above.
        PREFERRED OPTION!
    ]]--
    _table["weapon_state_rtb"] = 3  -- 3 = YesLeaveGroup
    _table["engage_opportunity_targets"] = false    -- Don't engage non-mission contacts
    _table["engaging_ambiguous_targets"] = 1        -- optimistic
    
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

local _table = {name='EMB-145I AEW #1', guid='9V0YME-0HN2T4E5VHG8U'}
local escortee = ScenEdit_GetUnit(_table)
local _side_name = ScenEdit_PlayerSide()

print(CMOT_Escort_Escorts)
CMOT_Escort_Init(escortee, 50)
print(CMOT_Escort_Escorts)
--CMOT_Escort_Clear()