--[[
    Instructions:
        Setup:
            -Switch to Civilian Side
            -Create a Standard Zone with zone name "CMOT CA"
            -Use the DrawPolygon tool in the Area/Reference manager

        Airport Deletion:
            -DONT invividually delete any airport (Future fix will be implemented)
            -Use global function "function CMOT_Delete_CA(data)" to delete a unit
                -Parameter "data" can be a either a table with guid key or a guid string

        Accidental Deletion of airport:
            -Use global function "CMOT_CA_Aircraft_Clear()" to clear all aircrafts (Not' Aircrafts though)
            -Run the code again
        
    
    

    Glossary:
        CA:     Civilian Airports
        CMOT:   Command: Modern Operations ToolKit
        RP:     Reference Point

    Functions:
        Global:
            CMOT_Delete_CA(data)                Parameters: String guid or a table (table that contains a key 'guid')
            CMOT_CA_Aircraft_Clear()
        Local:
            CMOT_Create_CA(zone_name)           Parameters: String
            CMOT_Create_Facility_atRP(actual_rp)    Parameters: RP Wrapper
            CMOT_Airport_Exist_atRP()
            CMOT_CA_Mission(_side_name)         Paramaters: String
            CMOT_CA_Units(_side_name)           Paramaters: String

    Values:
        CMOT_CA
            Type: Table
            Contents: Keeps track of all the Civilian Airports
    Other Information:
        Civilian Planes:
            Small:
                Socata TB-20 Trinidad (Civilian - 1982)             5960
                Cessna 172P Skyhawk (Civilian - 1981)               6451
                Cessna 208A-675 Caravan (Civilian - 1998)           3946

            Medium:
                Cessna 560 Citation Ultra (Civilian - 1995)         4257
                Learjet 36A (Civilian - 1977)                       4012
                
        Commercial Planes:
            Small:
                King Air 350 (Commercial - 1991)                    3244
                Pilatus PC-12 (Commercial - 1994)                   3324
                Super King Air 350ER (Commercial - 2007)            5344

            Medium:
                ATR-72-500 (Commercial - 1999)                      2591
                ATR-72-600 (Commercial - 2010)                      5499
                Gulfstream G550 (Commercial - 2004)                 2898

            Large:
                Boeing 787-10 Dreamliner (Commercial - 2018)        3976

            Very Large:
                Boeing 747-400ERF (Commercial - 2003)               2536

            Freighter:
                Boeing 747-400F (Commercial - 1994)                 2533

            Special:
                Concorde (Commercial - 1969)                        4452
                A.300-600ST Beluga (Commercial - 1995)              4613

                    
]]--

local function CMOT_Aircrafts_Init()
    CMOT_CA_Aircrafts = {}
    CMOT_CA_Aircrafts.civ={}
    CMOT_CA_Aircrafts.civ.small={}
    CMOT_CA_Aircrafts.civ.medium={}
    CMOT_CA_Aircrafts.civ.small[1]={name="Socata TB-20 Trinidad", dbid = 5960, loadoutid=31885}
    CMOT_CA_Aircrafts.civ.small[2]={name="Cessna 172P Skyhawk", dbid = 6451, loadoutid=8398}
    CMOT_CA_Aircrafts.civ.small[3]={name="Cessna 208A-675 Caravan", dbid = 3946, loadoutid=19790}
    CMOT_CA_Aircrafts.civ.small[4]={name="Learjet 36A", dbid = 4012, loadoutid=20017}
    CMOT_CA_Aircrafts.civ.medium[1]={name="ATR-72-500", dbid=2591, loadoutid=10125}
    CMOT_CA_Aircrafts.civ.medium[2]={name="ATR-72-600", dbid=5499, loadoutid=30083}
    CMOT_CA_Aircrafts.civ.medium[3]={name="Gulfstream G550", dbid=2898, loadoutid=15009}
    print(CMOT_CA_Aircrafts)
end
local function CMOT_CA_Assign_to_Mission(_side_name)
    if _side_name==nil then
        _side_name = ScenEdit_PlayerSide()
    end
    for i=1, #CMOT_CA_Aircrafts_Units do
        ScenEdit_AssignUnitToMission(CMOT_CA_Aircrafts_Units[i], CMOT_CA_Aircraft_Mission.guid)
    end
end
local function CMOT_CA_AddAircrafts(_side_name)
    if _side_name==nil then
        _side_name = ScenEdit_PlayerSide()
    end
    local aircraft_category = CMOT_CA_Aircrafts.civ.medium
    local max_position = #aircraft_category 
    local max_ready_time = 240
    
    local _table={}
    _table["type"]="Aircraft"
    _table["side"]=_side_name
    for position=1, max_position do
        local num_aircraft = math.random(1,10)      -- <------------------Max Number of aircraft for each specific class
        for i=1, num_aircraft do
            local random_index = math.random(1,#CMOT_CA)
            local random_base = CMOT_CA[random_index]
            _table["base"]=random_base.guid
            _table["unitname"]=aircraft_category[position].name.." #"..i
            _table["dbid"]=aircraft_category[position].dbid
            _table["loadoutid"]=aircraft_category[position].loadoutid
            
            local _unit = ScenEdit_AddUnit(_table)
            ScenEdit_SetUnit({guid=_unit.guid, timetoready_minutes=math.random(0,max_ready_time)})
            table.insert(CMOT_CA_Aircrafts_Units, _unit.guid)
        end
    end
    print(CMOT_CA_Aircrafts_Units)
end

local function CMOT_CA_Mission(_side_name)
    CMOT_CA_Aircraft_Mission = ScenEdit_AddMission(_side_name, "CMOT CA Ferry Mission", "Ferry", {destination=CMOT_CA[1].guid})
    ScenEdit_SetMission(_side_name, CMOT_CA_Aircraft_Mission.guid, {FerryBehavior = 'Random', UseFlightSize = 'False'})
    ScenEdit_SetEMCON ('Mission', "CMOT CA Ferry Mission", 'Radar=Active')
end


function CMOT_Delete_CA(data)
    local function delete_from_CMOT_CA(_guid)
        for k,airport in pairs(CMOT_CA) do
            if airport.guid == _guid then
                table.remove(CMOT_CA, k)
                return
            end
        end
        error("Unexpected error: Unit is deleted, but still exists CMOT_CA table", 2)
    end
    if is_table(data) and data.guid then
        ScenEdit_DeleteUnit({guid = data.guid})
        delete_from_CMOT_CA(data.guid)
        return
    elseif is_string(data) then
        ScenEdit_DeleteUnit({guid = data})
        delete_from_CMOT_CA(data)
        return
    end
    error("Invalid Parameter: Must be string guid or a table (table that contains a key \'guid\')", 2)
end

local function CMOT_Airport_Exist_atRP(rp_latitude, rp_longitude)
    if table_length(CMOT_CA)==0 then
        return false
    end
    for k, airport in pairs(CMOT_CA) do     -- if airport already exist at selected RP
        if airport.latitude == rp_latitude and airport.longitude == rp_longitude then
            return true
        end
    end
    return false
end

local function CMOT_Create_Facility_atRP(_rp, _dbid, _side_name)
    if is_empty(_side_name) then
        local _side = ScenEdit_PlayerSide()
    elseif is_not_string(_side_name) then
        error("Invalid Parameter #2: Expected a non-empty string", 2)
    end
    if CMOT_Airport_Exist_atRP(_rp.latitude, _rp.longitude) then
        return
    end
    local _unit = ScenEdit_AddUnit({type="Facility", side=_side_name, dbid=_dbid, latitude=_rp.latitude, longitude=_rp.longitude, name="Airport #"..table_length(CMOT_CA)+1})
    
    table.insert(CMOT_CA, {
        name = _unit.name,
        guid = _unit.guid,
        latitude = _unit.latitude,
        longitude = _unit.longitude})
end

local function CMOT_Create_CA(_zone_name, _side_name)
    if is_empty(_zone_name) or is_not_string(_zone_name) then
        error("Invalid Parameter #1: Expected a non-empty string", 2)
    end
    if is_empty(_side_name) then
        _side_name = ScenEdit_PlayerSide()
    elseif is_not_string(_side_name) then
        error("Invalid Parameter #2: Expected a non-empty string", 2)
    end
    local _zone = VP_GetSide({name = _side_name}):getstandardzone(_zone_name)  --Gets the Side's Standard zone by name
    local _zone_area = _zone.area   -- Gets the zone's area

    for k, _rp in pairs(_zone_area) do
        local actual_rp = ScenEdit_GetReferencePoint ({side = _side_name, name = _rp.guid})
        CMOT_Create_Facility_atRP(actual_rp, 2416 , _side_name)
    end
    CMOT_CA_Mission(_side_name)
    CMOT_Aircrafts_Init()
    CMOT_CA_AddAircrafts(_side_name)
    CMOT_CA_Assign_to_Mission(_side_name)
end




local function Test()
    CMOT_Create_CA("CMOT CA")
    for k,airport in pairs(CMOT_CA) do
        for k, property in pairs(airport) do
            print(k.."\t"..property)
        end
        print("")
    end
    print(CMOT_CA)
end

function CMOT_CA_Aircraft_Clear()
    CMOT_CA={}
    CMOT_CA_Aircrafts_Units={}
    ScenEdit_DeleteMission(ScenEdit_PlayerSide(), CMOT_CA_Aircraft_Mission.name)
end



-- Creating a CMOT_CA table
if is_nil(CMOT_CA) or is_not_table(CMOT_CA) or is_nil(CMOT_CA_Aircrafts_units) or is_not_table(CMOT_CA_Aircrafts_Units) then
    CMOT_CA={}
    CMOT_CA_Aircrafts_Units={}
end



--Test()
--CMOT_CA_Aircraft_Clear()