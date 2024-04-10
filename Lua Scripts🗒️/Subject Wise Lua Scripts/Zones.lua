--[[
    Glossary:
        RP: Abbreviation for Reference Points
    
    Functions:
        <<Standard Zone>>
            get_standardzone_rp_name(side, zone_name)   --Parameters: Side, ZoneName
            rename_standardzone_rp_name(side, zone_name,prefix) --Parameters: Side, ZoneName, PrefixString
]]--





-----**Main Functions**-----

-----<<STANDARD ZONE>>-----
-----Get the name of the RP of a zone-----
local function get_standardzone_rp_name(_side_name, _zone_name)
    if is_empty(_side_name) or is_not_string(_side_name) then
        error("Invalid Parameter #1: Expected a non-empty string", 2);
    elseif is_empty(_zone_name) or is_not_strong(_zone_name) then
        error("Invalid Parameter #2: Expected a non-empty string", 2);
    end
    local _zone = VP_GetSide({name = _side_name}):getstandardzone(_zone_name)  --Gets the Side's Standard zone by name
    local _zone_area = _zone.area   -- Gets the zone's area
    
    local _zone_rp_names = {}   -- A table to store the names of the RPs
    for k, _rp in pairs(_zone_area) do
        table.insert(_zone_rp_names,_rp.name)
    end
    return _zone_rp_names   -- Returns a table that contains the name of the Reference Points
end
-----------------------------------------



-----Rename standard zone RP name-----
local function rename_standardzone_rp_name(_side_name, _zone_name,i_prefix)
    local _zone = VP_GetSide({name=_side_name}):getstandardzone(_zone_name)    --Gets the Side's Standard zone by name
    local _zone_area = _zone.area   --Gets the zone's area
    
    --Error Handling
    if is_empty(_zone_area) then
        print("Warning: Standard Zone \'".._zone_name.."\' has no RPs")
        return -1
    end

    local _rp_count = 1 --Suffix number
    for k,_rp in pairs(_zone_area) do       --For every RP of the zone
        local _actual_rp = ScenEdit_GetReferencePoint({side=_side_name, guid=_rp.guid}) --gets the actual RP as a RP wrapper
        _actual_rp.name = tostring(i_prefix)..tostring(_rp_count)   --Changes the name
        _rp_count = _rp_count + 1   --Increment Suffix name
    end
end
--------------------------------------