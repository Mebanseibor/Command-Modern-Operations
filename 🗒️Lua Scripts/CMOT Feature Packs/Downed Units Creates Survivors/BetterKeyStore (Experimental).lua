-- Functions
    -- KeyStore_SetTable(name, table, forCampaign)
    -- KeyStore_GetTable(name)

-- Instructions:
--     Setup:
--         -Setup an Event with trigger "ScenarioIsLoaded"
--         -Add a LuaScript Action with this script to load the script everytime the Scenario is loaded
--         -It is recommended to place this Action at the top of the actions (if any) for the Event to prevent any "function not found" error
--          -Either Save and Load the scenario to bootup the Script, or Run this code once in the console to enable the functions

-- Purpose:
--     Since the Game function "ScenEdit_SetKeyValue()" can only store non-empty strings but not tables, this script allows tables to also be stored

    


    
local UnicodeHex_OpenSymbol = 0x00AB
local UnicodeHex_CloseSymbol = 0x00BB
local UnicodeInt_OpenSymbol = tonumber("AB",16)
local UnicodeInt_CloseSymbol = tonumber("BB",16)
Char_OpenSymbol = utf8.char(UnicodeHex_OpenSymbol)
Char_CloseSymbol = utf8.char(UnicodeHex_CloseSymbol)

--<<TAGS>>--
local Tag_TableStart = Char_OpenSymbol.."TABLE_START"..Char_CloseSymbol.."\r\n"
local Tag_TableEnd = Char_OpenSymbol.."TABLE_END"..Char_CloseSymbol.."\r\n"
local Tag_KeyStoreStart = Char_OpenSymbol.."KeyStoreStart"..Char_CloseSymbol.."\r\n"
local Tag_KeyStoreEnd = Char_OpenSymbol.."KeyStoreEnd"..Char_CloseSymbol.."\r\n"
local Tag_Key = Char_OpenSymbol.."Key"..Char_CloseSymbol
local Tag_ValueString = Char_OpenSymbol.."ValueString"..Char_CloseSymbol
local Tag_ValueNumber = Char_OpenSymbol.."ValueNumber"..Char_CloseSymbol
local Tag_ValueBoolean = Char_OpenSymbol.."ValueBoolean"..Char_CloseSymbol
local Tag_ValueTable = Char_OpenSymbol.."ValueTable"..Char_CloseSymbol





--<<STORING>>--
function KeyStore_SetTable(name, _table, forCampaign)
    --Error Handling
    if type(name)~="string" or name=="" then
        ScenEdit_MsgBox("Error\r\nFunction \'KeyStore_SetTable(name, _table, forCampaign)\'\r\nParameter #1: Expected a non-empty string", 6)
        error("Invalid Parameter #1: Expected a non-empty string", 2)
    elseif type(_table)~="table" then
        ScenEdit_MsgBox("Error\r\nFunction \'KeyStore_SetTable(name, _table, forCampaign)\'\r\nParameter #2: Expected a table", 6)
        error("Invalid Parameter #2: Expected a table", 2)
    end
    if forCampaign~=nil then
        if type(forCampaign)~="boolean" then
            ScenEdit_MsgBox("Error\r\nFunction \'KeyStore_SetTable(name, _table, forCampaign)\'\r\nParameter #3: Expected a boolean", 6)
            error("Invalid Parameter #3: Expected a boolean", 2)
        end
    else
        forCampaign=false
    end
    
    local function KeyStore_BuildString(_table)
        local str = ""
        str = str.."\r\n"
        str = str..Tag_TableStart
        for k, v in pairs(_table) do
            --Key
            str = str..Tag_Key..k..Tag_Key.."\r\n"
            


            --Value
            if type(v)=="number" then
                str = str..Tag_ValueNumber..v..Tag_ValueNumber
            elseif type(v)=="string" then
                str = str..Tag_ValueString..v..Tag_ValueString
            elseif type(v)=="boolean" then
                local BooleanString = v and "true" or "false"
                str = str..Tag_ValueBoolean..BooleanString..Tag_ValueBoolean
            elseif type(v)=="table" then
                str = str..Tag_ValueTable..Tag_ValueTable.."\r\n"
                str = str..KeyStore_BuildString(v)
            end
            
            --NewLine
            str = str.."\r\n"
        end
        str = str..Tag_TableEnd
        return str
    end
    
    
    local stringTable = Tag_KeyStoreStart..KeyStore_BuildString(_table)..Tag_KeyStoreEnd
    ScenEdit_SetKeyValue (name, stringTable, forCampaign)
end











--<<Retrieving>>--
function KeyStore_GetTable(name)
    --Error Handling
    if type(name)~="string" or name=="" then
        ScenEdit_MsgBox("Error\r\nFunction \'KeyStore_GetTable(name)\'\r\nParameter #1 should be a non-empty string", 6)
        error("Invalid Parameter #1: Expected a non-empty string", 2)
    end


    local KeyStore_ActualKey = ScenEdit_GetKeyValue(name)
    
    --Error Handling for Empty/invalid key
    if KeyStore_ActualKey=="" then return {} end

    --print(KeyStore_Key)
    KeyStore_ActualKey = KeyStore_ActualKey:gsub("\n","\r\n")

    function LoopThroughTableTag(Str, KeyStore_Value_PositionPointer)

        local KeyStore_Key = Str
        
        --Move pointer just over the first tag of "TABLE_START"
        local startPos, endPos = Str:find("«TABLE_START»")
        KeyStore_Value_PositionPointer = endPos+1

        local Key = ""
        
        local function GetPos_NextOpenSymbol(Position)
            return KeyStore_Key.find(KeyStore_Key, Char_OpenSymbol, Position)
        end
        local function GetPos_NextCloseSymbol(Position)
            return KeyStore_Key.find(KeyStore_Key, Char_CloseSymbol, Position)
        end

        local function Get_ActualContent(Tag)
            local Content = string.sub(KeyStore_Key, KeyStore_Value_PositionPointer+2, GetPos_NextOpenSymbol(KeyStore_Value_PositionPointer)-1)
            --string
            if Tag=="ValueString" then
                return Content
            
            --number
            elseif Tag=="ValueNumber" then
                return tonumber(Content)
            --boolean
            elseif Tag=="ValueBoolean" then
                if Content == "true" then return true
                else return false end
            --table
            end
        end
        
    
        local _table = {}
        local looplimit=string.len(KeyStore_Key)    --For Fault Handling

        while Tag~="TABLE_END" or Tag~="KeyStoreEnd" do
            if KeyStore_Value_PositionPointer==string.len(KeyStore_Key) then break end

            local char = string.sub(KeyStore_Key, KeyStore_Value_PositionPointer, KeyStore_Value_PositionPointer)
            local UnicodeInt_Char = string.byte(KeyStore_Key, KeyStore_Value_PositionPointer)
            local UnicodeHex_Char = string.format("%X", UnicodeInt_Char)

            if(UnicodeInt_Char==UnicodeInt_OpenSymbol) then
                local Position_CloseSymbol = GetPos_NextCloseSymbol(KeyStore_Value_PositionPointer + 1)

                local Tag = string.sub(KeyStore_Key, KeyStore_Value_PositionPointer+1, Position_CloseSymbol-1)

                --Hop the pointer over to the closing symbol of the Opening Tag
                KeyStore_Value_PositionPointer = Position_CloseSymbol

                --Get Position of the starting symbol of the Closing Tag
                local Position_ClosingTag = GetPos_NextOpenSymbol(KeyStore_Value_PositionPointer)


                if Tag=="TABLE_END" then
                    return _table

                --Check if Key
                elseif Tag=="Key" then
                    --Get Key
                    
                    Key = string.sub(KeyStore_Key, Position_CloseSymbol+2, Position_ClosingTag-1) -- Advancing the forwarad pointer by +2 to omit the extra character unrecognized by Lua
                    
                    --Determine Key Datatype
                    if tonumber(Key) then
                        Key=tonumber(Key)
                    end
                
                --Check if ValueString
                elseif Tag=="ValueString" then
                    _table[Key] = Get_ActualContent(Tag)

                --Check if ValueNumber
                elseif Tag=="ValueNumber" then
                    _table[Key] = Get_ActualContent(Tag)
                
                --Check if ValueBoolean
                elseif Tag=="ValueBoolean" then
                    _table[Key] = Get_ActualContent(Tag)
                
                --Check if ValueTable
                elseif Tag=="ValueTable" then
                    --Move pointer when just before the first tag "TABLE_START"
                    local startPos, endPos = Str:find("«TABLE_START»", KeyStore_Value_PositionPointer)
                    KeyStore_Value_PositionPointer = startPos
                    

                    local TempstartPos, endPos = Str:find("«TABLE_START»\r\n«TABLE_END»", KeyStore_Value_PositionPointer)
                    local StringStartingFromUpcomingTable = string.sub(Str, KeyStore_Value_PositionPointer, string.len(Str))
                    
                    if TempstartPos == KeyStore_Value_PositionPointer then
                        _table[Key] = {}
                    else
                        _table[Key] = LoopThroughTableTag(StringStartingFromUpcomingTable, KeyStore_Value_PositionPointer)
                    end
                    --Move pointer just after the first encounter with tag "TABLE_END"
                    local startPos, endPos = Str:find("«TABLE_END»", KeyStore_Value_PositionPointer)
                    Position_ClosingTag = startPos
                    KeyStore_Value_PositionPointer = endPos-1
                else
                    KeyStore_Value_PositionPointer=Position_CloseSymbol+1
                end
                
                --When work on the Tag is done, move the pointer to the CloseSymbol of the Ending Tag
                --Finding CloseSymbol of Closing Tag
                local Position_CloseSymbol = GetPos_NextCloseSymbol(Position_ClosingTag + 1)
                --Hop the pointer just after the Closing Tag
                KeyStore_Value_PositionPointer = Position_CloseSymbol
            end
            --Next Character
            KeyStore_Value_PositionPointer=KeyStore_Value_PositionPointer+1
            
            --Loop Safety Measure
            looplimit=looplimit-1
            if looplimit==0 then
                print("Encounted Possible Infinite Loop, Breaking!!!")
                --ScenEdit_MsgBox("Encounted Possible Infinite Loop, Breaking!!!", 6)
                --error("Infinite Loop: Encounted Possible Infinite Loop, Breaking!!!", 1)
                return _table
            end
        end
        return _table
    end
    local AssembledTable = LoopThroughTableTag(KeyStore_ActualKey, 1)
    return AssembledTable
end

local T = { SpecialActions = { }, Conditions = { }, Triggers = { }, Events = { [1] = '9V0YME-0HN38I4UMRUT1' }, Actions = { } }
KeyStore_SetTable("T", T)
print(KeyStore_GetTable("T"))
-- Infinite Loop Encounter for "last element", it did not get included, regardless if it had any elements or not