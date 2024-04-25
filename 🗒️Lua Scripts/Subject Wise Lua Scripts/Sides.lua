-----Functions-----
--[[
    ScenEdit_AddSides(sides_name)    --Parameters: Table of strings
    
]]--





-----*****Main Functions*****-----
function ScenEdit_AddSides(sides_name)
    -- Error Handling
    if type(sides_name)~="table" then
        print("Error: Input is not a table")
        return -1
    end
    if is_empty(sides_name) then
        print("Warning: Table is empty")
        return -1
    end

    local function get_all_sides_name()
        if is_empty(VP_GetSides()) then
            return {}
        end
        
        local _sides = {}
        for k,_side in pairs(VP_GetSides()) do
            table.insert(_sides,_side.name)
        end
        return _sides
    end

    local existing_sides=get_all_sides_name()
    for k,_side in pairs(sides_name) do
        if not(table_has_element(existing_sides,_side)) then
            ScenEdit_AddSide({side=_side})
        end
    end
end