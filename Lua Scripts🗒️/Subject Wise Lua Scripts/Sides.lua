-----Functions-----
--[[
    ScenEdit_AddSides(sides_name)    --Parameters: Table of strings
    
]]--

-----**Utility Functions**-----
function is_empty(data)
    if data==nil or #data==0 then return true end
    return false
end

function table_has_element(_table,_element)
    -- Error Handling
    if type(_table)~="table" then
        print("Error: Input is not a table")
        return false
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