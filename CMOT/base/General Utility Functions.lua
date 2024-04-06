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
    if data==nil or (is_not_boolean(data) and is_not_number(data) and #data == 0) then return true
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

-----<<Scripts>>-----
function run_script(script,folder)
    if is_empty(script) and is_not_string(script)then
        error("Invalid Parameter #1: Expected non-empty String",2)
    end
    if is_empty(folder) then
        if is_nil(CMOT) then
            folder = "" --Searches script in "Lua" Folder
        else
            folder = CMOT.."Scripts/"   --Searches script in CMOT\Scripts\
        end
    elseif is_not_string(folder) then
        error("Invalid Parameter #2: Expected a string",2)
    elseif folder:sub(-1)~="/" then
        error("Invalid Parameter #2: Should end in a \'/\'",2)
    end
    Tools_lua = folder..script..".lua"
    ScenEdit_RunScript(Tools_lua)
end
---------------------------------

-----<<Quality of Life>>-----
function printv(text,data)
    print(text.."\t"..tostring(data))
end
----------------------------