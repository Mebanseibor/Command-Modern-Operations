--[[
    Functions:

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
function 