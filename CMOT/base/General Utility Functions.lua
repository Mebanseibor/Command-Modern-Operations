--[[
    Functions:
        is_boolean(data)
        is_boolean(data)
        is_number(data)
        is_number(data)
        is_table(data)
        is_table(data)
        is_string(data)
        is_string(data)
        is_nil(data)
        is_empty(data)

        
        table_has_element(table,element)
        table_length()          --accounts for tables with keys also
        printv(text,data)       --Meant for Faster Debugging by printing variable value with text
        TOSTRING(data)          --returns the data as string (Applies for tables too, but does print a nil or non-existant variable)
        
        run_script(script,folder) --Caters to CMOT (Command Modern Operations Toolkit)
    
    Values:
        game_tick_second=10000000 --A second in in-game ticks
]]--

-----values-----
game_tick_second=10000000
----------------

-----**GENERAL UTILITY FUNCTIONS**-----
--<<Booleans>>--
function is_boolean(data)return type(data)=="boolean" end
function is_not_boolean(data)return type(data)~="boolean" end
function is_number(data)return type(data)=="number" end
function is_not_number(data)return type(data)~="number" end
function is_table(data)return type(data)=="table" end
function is_not_table(data)return type(data)~="table" end
function is_string(data)return type(data)=="string" end
function is_not_string(data)return type(data)~="string" end
function is_nil(data)return type(data)=="nil" end

function is_empty(data)
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
function table_has_element(_table,_element)
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

function table_length(_table)
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



-----<<Scripts>>-----
function run_script(script,folder)
    if is_empty(script) and is_not_string(script)then
        error("Invalid Parameter #1: Expected non-empty String",2)
    end
    if is_empty(folder) then
        folder = ""
    elseif is_not_string(folder) then
        print(type(folder))
        error("Invalid Parameter #2: Expected a string",2)
    end
    if folder:sub(-1)~="/" then
        folder=folder.."/"
    end
    Tools_lua = folder..script..".lua"
    ScenEdit_RunScript(Tools_lua)
end
---------------------------------

-----<<Quality of Life>>-----
function printv(text,data)
    print(text.."\t"..tostring(data))
end





function TOSTRING(data)
    if is_nil(data) then        --is nil
        return "nil"
    elseif is_empty(data) then  --is empty entity
        if is_table(data) then  --is empty table
            return "{}"
        else                    --is empty string
            return ""
        end
    elseif is_table(data) then --is table
        local str = "{"
        for k,v in pairs(data) do
            str = str..TOSTRING(v)..", "
        end
        str = string.sub(str, 1, -3)
        str=str.."}"
        return str
    elseif is_string(data) then --is string
        return data
    elseif is_number(data) then --is number    
        return tostring(data)
    elseif is_boolean(data) then    --is boolean
        return tostring(data)
    end
end
----------------------------