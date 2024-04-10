--[[
    Glossary:
        CA:     Civilian Airports
        CMOT:   Command: Modern Operations ToolKit
        RP:     Reference Point

    Functions:
        CMOT_Create_CA(zone_name)           Parameters: String
        CMOT_Create_Unit_atRP(actual_rp)    Parameters: RP Wrapper
        CMOT_Airport_Exist_atRP()
    Values:
        CMOT_CA
            Type: Table
            Contents: Keeps track of all the Civilian Airports
]]--





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
    error("Invalid Parameter: Must be string GUID or a table (table that contains a key \'guid\')", 2)
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

local function CMOT_Create_Unit_atRP(_rp, _dbid, _side_name)
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
        CMOT_Create_Unit_atRP(actual_rp, 2416 , _side_name)
    end
    return _zone_rp_names   -- Returns a table that contains the name of the Reference Points
end




local function Test()
    print(TOSTRING(CMOT_CA))
    for k,airport in pairs(CMOT_CA) do
        for k, property in pairs(airport) do
            print(k.."\t"..property)
        end
        print("")
    end
    print(TOSTRING(CMOT_CA))
end




-- Creating a CMOT_CA table
if is_nil(CMOT_CA) or is_not_table(CMOT_CA) then
    CMOT_CA={}
end


CMOT_Create_CA("CMOT CA")
Test()