--[[
    Glossary:
        RP: Abbreviation for Reference Points
    
    Variable pre-fix Meanings:
        v_      [v_abc]   :   main body variables
        i_      [i_abc]   :   variable that is inputted into a function (as a parameter)
        _       [_abc]    :   variables defined only within a function
        lf_     [lf_abc]  :   variable defined only within a local function (when a local function is within a function)
]]--


-----Checks if a table is empty or not-----
local function is_table_empty(lf_table)
    if lf_table==nil or #lf_table==0 then return true
    else return false end
end
-------------------------------------------



local v_side = "Blue"   -- Enter the Side name
local v_zone_name = "Zone 01"   -- Enter the zone name



-----*****STANDARD ZONE*****-----

-----Get the name of the RP of a zone-----
local function get_standardzone_rp_name(i_side, i_zone_name)
    local _zone = VP_GetSide({name = i_side}):getstandardzone(i_zone_name)  --Gets the Side's Standard zone by name
    local _zone_area = _zone.area   -- Gets the zone's area
    
    local _zone_rp_names = {}   -- A table to store the names of the RPs
    for k, _rp in pairs(_zone_area) do
        table.insert(_zone_rp_names,_rp.name)
    end
    return _zone_rp_names   -- Returns a table that contains the name of the Reference Points
end

local _standard_zone_rp_name = get_standardzone_rp_name(v_side , v_zone_name)    --Parameters: Side, Standard Zone name
print(_standard_zone_rp_name)
-----------------------------------------



-----Rename standard zone RP name-----
local function rename_standardzone_rp_name(i_side, i_zone_name,i_prefix)
    local _zone = VP_GetSide({name=i_side}):getstandardzone(i_zone_name)    --Gets the Side's Standard zone by name
    local _zone_area = _zone.area -- Gets the zone's area
    
    --Error Handling
    if is_table_empty(_zone_area) then
        print("Warning: Standard Zone \'"..i_zone_name.."\' has no RPs")
        return -1
    end

    local _rp_count = 1 --Suffix number
    for k,_rp in pairs(_zone_area) do       --For every RP of the zone
        local _actual_rp = ScenEdit_GetReferencePoint({side=i_side, guid=_rp.guid}) --gets the actual RP as a RP wrapper
        _actual_rp.name = tostring(i_prefix)..tostring(_rp_count)   --Changes the name
        _rp_count = _rp_count + 1   --Increment Suffix name
    end

end
local v_prefix = "Alpha-"
rename_standardzone_rp_name(v_side, v_zone_name, v_prefix)   --Parameters: Side name, Standard Zone Name, Prefix
--------------------------------------