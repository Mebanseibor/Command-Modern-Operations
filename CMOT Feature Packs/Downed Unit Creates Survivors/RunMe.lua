--[[
    Development Notes:
]]--

-- Scripts Last Updated On:     2024/07/15      (YYYY/MM/DD)



--<<LuaScripts>>--
-------------------------------------------------------------------
local LuaScript_CMOTBetterKeyStore = [[
--LuaScriptStart
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
--LuaScriptEnd
]]
-------------------------------------------------------------------
local LuaScript_CMOT_SAR_Aircraft_GetKeys = [[
--LuaScriptStart        
    -- For Common Components
        --For ScenarioLoaded
            TriggerGuid_CMOT_ScenarioLoaded  = ScenEdit_GetKeyValue("TriggerGuid_CMOT_ScenarioLoaded")
            -- CMOT Utilities Scripts:
                ActionGuid_CMOT_BetterKeyStore = ScenEdit_GetKeyValue("ActionGuid_CMOT_BetterKeyStore")
            -- Guid of the Action that will run this script
                ActionGuid_CMOT_SAR_Aircraft_GetKeys = ScenEdit_GetKeyValue("ActionGuid_CMOT_SAR_Aircraft_GetKeys")


    --table
    PackageComponents_CMOT_SAR = KeyStore_GetTable("PackageComponents_CMOT_SAR")
    DependantPackageComponents_CMOT_SAR = KeyStore_GetTable("DependantPackageComponents_CMOT_SAR")
    CMOT_SAR_Aircraft_SurvivorList = KeyStore_GetTable("CMOT_SAR_Aircraft_SurvivorList")
    CMOT_SAR_AircraftWreckageList = KeyStore_GetTable("CMOT_SAR_AircraftWreckageList")


    --string
    CMOT_SAR_PlayerSide = ScenEdit_GetKeyValue("CMOT_SAR_PlayerSide")
    CMOT_SAR_SARSide = ScenEdit_GetKeyValue("CMOT_SAR_SARSide")



    --number
    CMOT_SAR_AircraftWreckageLimit = tonumber(ScenEdit_GetKeyValue("CMOT_SAR_AircraftWreckageLimit"))
    --CMOTPackagesCount = tonumber(ScenEdit_GetKeyValue("CMOTPackagesCount"))
--LuaScriptEnd
]]
-------------------------------------------------------------------
local LuaScript_UnitCreationUponDestruction = [[
--LuaScriptStart
    --<<Objects and other information>>--
    local _unit = ScenEdit_UnitX()
    local _proficiency = _unit.proficiency
    local is_OutOfFuel = (_unit.fuel[2001].current<=1) --fuel[2001] is aviation fuel



    --<<Probabilities>>--
    local base_probability = 0.5
    local wreckage_probability = 0.20
    local prob_proficiency = 0.0
    local prob_OutOfFuel = 0.6



    --<<Values and Thresholds>>--
    --factors--
    local factor_proficiency = 1.0

    --survivor distance from wreckage
    local min_distance_from_wreckage = 0.5    --in nm
    local max_distance_from_wreckage = 1.5    --in nm
    local distance_decimal_place = 10


    --proficiencies--
    local prob_proficiency_Novice = 0.1
    local prob_proficiency_Cadet = 0.2
    local prob_proficiency_Regular = 0.3
    local prob_proficiency_Veteran = 0.5
    local prob_proficiency_Ace = 0.6



    --<<Calculations>>--
    --Out of fuel
    if is_OutOfFuel then
        wreckage_probability = wreckage_probability + prob_OutOfFuel
    end
    --proficiency
    if _proficiency == "Novice" then
        prob_proficiency = prob_proficiency_Novice
    elseif _proficiency == "Cadet" then
        prob_proficiency = prob_proficiency_Cadet
    elseif _proficiency == "Regular" then
        prob_proficiency = prob_proficiency_Regular
    elseif _proficiency == "Veteran" then
        prob_proficiency = prob_proficiency_Veteran
    elseif _proficiency == "Ace" then
        prob_proficiency = prob_proficiency_Ace
    end
    prob_proficiency = prob_proficiency*factor_proficiency





    local function Create_Wreckage()
        local random_number = math.random()
        if random_number <= wreckage_probability then

            -- Delete older wreckage if AircraftWreckageLimit is reached (if any)
                if #CMOT_SAR_AircraftWreckageList==CMOT_SAR_AircraftWreckageLimit then
                    ScenEdit_DeleteUnit(CMOT_SAR_AircraftWreckageList[1])
                    table.remove(CMOT_SAR_AircraftWreckageList, 1)
                end

            
            -- Create Aircraft Wreckage
                local _unit = ScenEdit_UnitX()
                local _table = {}
                _table.type = "Facility"
                _table.unitname = "Aircraft Wreckage of ".._unit.name
                _table.side = CMOT_SAR_SARSide
                _table.dbid = 2350
                _table.latitude = _unit.latitude
                _table.longitude = _unit.longitude
                _table.altitude = World_GetElevation({latitude = _unit.latitude, longitude=_unit.longitude})

                local _unit = ScenEdit_AddUnit(_table)
                _unit.autodetectable = false

            --Add the created Aircraft Wreckage to CMOT_SAR_AircraftWreckageList
                local _table = {}
                _table.guid = _unit.guid
                table.insert(CMOT_SAR_AircraftWreckageList, _table)
        end
    end

    local function Create_Survivor()
        local function RandomPoint(_latitude, _longitude, min, max, DecimalPlaces)   --DecimalPlaces is meant for conversion float values to Decimal by multiplication
            local _table = {}
            _table.latitude = _latitude
            _table.longitude = _longitude
            _table.distance = math.random(min, max)/DecimalPlaces
            _table.bearing = math.random(0,359)
            return World_GetPointFromBearing (_table)
        end

        --Conditions to not create any survivor:
        if(_unit.crew==0)then return end

        local random_number = math.random()
        if random_number <= prob_proficiency+wreckage_probability then
            local _table={}
            _table.type = "Facility"
            _table.unitname = "Survivor from ".._unit.name
            _table.side = CMOT_SAR_SARSide
            _table.dbid = 2441  --Personel
            local random_point = RandomPoint(_unit.latitude, _unit.longitude, min_distance_from_wreckage*distance_decimal_place, max_distance_from_wreckage*distance_decimal_place, distance_decimal_place)
            _table.latitude = random_point.latitude
            _table.longitude = random_point.longitude
            _table.altitude = World_GetElevation(random_point)
            local unit_Survivor = ScenEdit_AddUnit(_table)
            unit_Survivor.autodetectable = false

            -- for Extraction marker
            local unit_Marker = nil
            if true then
                _table.unitname = "Survivor Smoke Bomb"
                _table.dbid = 414
                local random_point = RandomPoint(unit_Survivor.latitude, unit_Survivor.longitude, 0.3, 0.5, 10)
                _table.latitude = random_point.latitude
                _table.longitude = random_point.longitude
                _table.altitude = World_GetElevation(random_point)
                unit_Marker = ScenEdit_AddUnit(_table)
                unit_Marker.autodetectable = false
            end
            table.insert(CMOT_SAR_Aircraft_SurvivorList, {survivor=unit_Survivor.guid, marker=unit_Marker.guid})
            KeyStore_SetTable("CMOT_SAR_Aircraft_SurvivorList", CMOT_SAR_Aircraft_SurvivorList)
        end
    end

    --<<Final Calculation>>--
    local random_number = math.random()
    if random_number<=base_probability then
        Create_Wreckage()
        Create_Survivor()
    end
--LuaScriptEnd
]]
-------------------------------------------------------------------
local LuaScript_IsContactASurvivor = [[
--LuaScriptStart
    local _unitContact = ScenEdit_UnitC()
    local actualID = _unitContact.actualunitid
    local _unitActualUnit = ScenEdit_GetUnit({guid=actualID})

    if _unitActualUnit.side~=ScenEdit_GetKeyValue("CMOT_SAR_SARSide") then     --If contact is not of SAR side
        return false
    end

    --Checking if unit is in SARSurvivorList "CMOT_SAR_Aircraft"
    for k, v in pairs(CMOT_SAR_Aircraft_SurvivorList) do
        if actualID == v.survivor then              --Checks if contact in Survivor List
            return true
        end
    end

    return false
--LuaScriptEnd
]]
--------------------------------------------------------------------
local LuaScript_ConvertDetectedSurvivors=[[
--LuaScriptStart
    local _unitContact = ScenEdit_UnitC()

    local _table = {}
    _table.guid = _unitContact.actualunitid
    _table.newSide = CMOT_SAR_PlayerSide
    ScenEdit_SetUnitSide (_table)

    ScenEdit_MsgBox("Survivor Found", 6)
--LuaScriptEnd
]]
--------------------------------------------------------------------
local LuaScript_SARSurvivorReachedBaseAsCargo=[[
--LuaScriptStart
    local _unitCargoHolder = ScenEdit_UnitX()

    local function SurvivorReachedBaseAsCargo(_unit)    
        --Check if Unit has 0 cargo
        if #_unit.cargo==0 then
            return false
        end
        
        local HasSurvivor = false
        local unitCargoHolder = _unit.cargo[1] --Since this unit doesn't host other units, therefore there will only be one element in the array
        
        for k, Cargo in pairs(unitCargoHolder.cargo) do
            --Matching _unitCargo to every Survivor from survivor list "CMOT_SAR_Aircraft"
            for k, v in pairs(CMOT_SAR_Aircraft_SurvivorList) do
                if Cargo.guid == v.survivor then
                    local Survivor = v.survivor --Note: It stores only the guid
                    local Marker = v.marker     --Note: It stores only the guid
                    

                    --<<What to do when Survivor is found in Cargo:>>
                    
                    --Delete Survivor (Since it is in Cargo, we have to delete it as Cargo)
                        ScenEdit_DeleteUnit({guid=Survivor}, false)
                        --Unload Cargo
                            local _table = {}
                            _table.guid = unitCargoHolder.guid      --Guid of CargoHolder
                            _table.mode = "remove_cargo"
                            _table.cargo = {Cargo.guid}
                            ScenEdit_UpdateUnitCargo(_table)
                        --Delete the Unloaded Cargo
                        ScenEdit_DeleteUnit(Cargo, false)

                    --Delete Survivor's Corresponding Marker
                        ScenEdit_DeleteUnit({guid=Marker}, false)
                    
                    --Update SurvivorList
                        table.remove(CMOT_SAR_Aircraft_SurvivorList, k)
                        KeyStore_SetTable("CMOT_SAR_Aircraft_SurvivorList", CMOT_SAR_Aircraft_SurvivorList)
                    
                    --Rewards:
                        ScenEdit_MsgBox("Survivor Was Rescued", 6)
                end
            end
        end
        
        
        return HasSurvivor
    end

    if SurvivorReachedBaseAsCargo(_unitCargoHolder) then
        ScenEdit_MsgBox("Survivor Has been Rescued", 6)
    end
--LuaScriptEnd
]]
--<<//LuaScripts>>--












--<<Text>>--
----------------------------------------------------------------------------------------
local Text_Recommendation = [[
Recommended Configuration for SAR Side:

- Set SAR side's Awareness Level to "Blind", to reduce unnecessary sensor calculations

- Set SAR side as Nuetral to all sides to prevent aggression

- Set SAR side's playability as "Computer-only"
]]

local Text_AircraftWreckageLimit = [[
Enter the maximum number of Aircraft Wreckage that can be present at a time

Purpose: This reduces Units in a scenario
]]

local Text_SARSide = [[
Select a Non-Combative, Nuetral Side for SAR
]]

local Text_PlayerSide = [[
Select Player's Side
]]

local Text_ReloadScenario = [[
For the scripts to take effect:
- Kindly save and reload the scenario
]]
----------------------------------------------------------------------------------------
--<<//Text>>--









--<<Individual Event/Trigger/Condition/Action/SpecialActions>>--
----------------------------------------------------------------------------------------
local function CMOT_SAR_Aircraft_Init()
    --Running BetterKeyStore in the current environment
        local function Run_BetterKeyStore()
            --LuaScriptStart
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
            --LuaScriptEnd
        end

    Run_BetterKeyStore()
    --Creation of table of guids to keep track of unshared Package components
        PackageComponents_CMOT_SAR = {Events={}, Triggers={}, Conditions={}, Actions={}, SpecialActions={}}
        KeyStore_SetTable("PackageComponents_CMOT_SAR", PackageComponents_CMOT_SAR)
    --Create a table of tables that kepp tracks of shared Package components
        DependantPackageComponents_CMOT_SAR = {}

    --<<EVENTS>>--
        local function Event_CMOT_ScenarioLoaded()
            local _table = {}
            _table.mode = "add"
            _table.IsRepeatable = true
            _table.isShown = false
            return _table
        end

        local function Event_CMOT_SAR_Aircraft_UnitCreationUponDestruction()
            local _table = {}
            _table.mode = "add"
            _table.IsRepeatable = true
            _table.isShown = false
            return _table
        end

        local function Event_CMOT_SAR_Aircraft_SARSurvivorIsFound()
            local _table = {}
            _table.mode = "add"
            _table.IsRepeatable = true
            _table.isShown = false
            return _table
        end

        local function Event_CMOT_SAR_Aircraft_SARSurvivorReachedBase()
            local _table = {}
            _table.mode = "add"
            _table.IsRepeatable = true
            _table.isShown = false
            return _table
        end
    --<<//EVENTS>>--
    
    
    --<<TRIGGERS>>--
        local function Trigger_CMOT_ScenarioLoaded()
            local _table = {}
            _table.mode = "add"
            _table.description = "ScenarioLoaded CMOT"
            _table.type = "ScenLoaded"
            return _table
        end

        local function Trigger_UnitIsDestroyed_PlayerAircraft()
            local _table = {}
            _table.mode = "add"
            _table.description = "UnitIsDestroyed PlayerAircraft"
            _table.type = "UnitDestroyed"
            _table.TargetFilter =    {
                                        TargetSide = CMOT_SAR_PlayerSide,   -- A Global Key
                                        TargetType = 1, --Aircraft
                                        TargetSubType = 0   --None
                                        }
            return _table
        end

        local function Trigger_UnitIsDetected_SARSurvivor_MobilePersonnel()
            local _table = {}
            _table.description = "UnitIsDetected SARSurvivor_MobilePersonnel"
            _table.mode = "add"
            _table.type = "UnitDetected"

            _table.TargetFilter =    {
                                        TargetSide = ScenEdit_GetKeyValue("CMOT_SAR_SARSide"),
                                        TargetType = 4,         --4 indicates "Land Facility"
                                        ShowAllTypes = true,
                                        TargetSubType = 5002,   --5002 indicates "Mobile Personnel"
                                        }
            _table.DetectorSideID = ScenEdit_GetKeyValue("CMOT_SAR_PlayerSide")
            _table.MCL = 1    --Minimum classification level, 1 indicates known Domain
            return _table
        end

        local function Trigger_UnitBaseStatus_PlayerAircraftLandedPostTouchdown()
            local _table = {}
            _table.mode = "add"
            _table.description = "UnitBaseStatus PlayerAircraftLandedPostTouchdown"
            _table.type = "UnitBaseStatus"
            _table.TargetCondition = 6   --6 Indicates "Landing_PostTouchDown"
            _table.TargetFilter = {
                                    TargetSide = CMOT_SAR_PlayerSide,
                                    TargetType = 1,             --1 indicates "Aircraft"
                                TargetSubType = 0           --0 Indicates "None"
            }
            return _table
        end
    --<<//TRIGGERS>>--
    



    --<<CONDITIONS>>--
        local function Condition_LuaScript_IsContactASurvivor()
            local _table = {}
            _table.mode = "add"
            _table.description = "LuaScript IsContactASurvivor"
            _table.type = "LuaScript"
            _table.ScriptText = LuaScript_IsContactASurvivor:gsub("\n    ", "\r\n")
            return _table
        end
    --<<//CONDITIONS>>--




    
    --<<ACTIONS>>--
        local function Action_LuaScript_CMOTBetterKeyStore()
            local _table = {}
            _table.mode = "add"
            _table.description = "LuaScript CMOTBetterKeyStore"
            _table.type = "LuaScript"
            _table.ScriptText = LuaScript_CMOTBetterKeyStore:gsub("\n    ", "\r\n")
            return _table
        end

        local function Action_LuaScript_CMOT_SAR_Aircraft_GetKeys()
            local _table = {}
            _table.mode = "add"
            _table.description = "LuaScript CMOT_SAR_Aircraft GetKeys"
            _table.type = "LuaScript"
            _table.ScriptText = LuaScript_CMOT_SAR_Aircraft_GetKeys:gsub("\n    ", "\r\n")
            return _table
        end

        local function Action_LuaScript_UnitCreationUponDestruction()
            local _table = {}
            _table.mode = "add"
            _table.description = "LuaScript UnitCreationUponDestruction"
            _table.type = "LuaScript"
            _table.ScriptText = LuaScript_UnitCreationUponDestruction:gsub("\n    ", "\r\n")
            return _table
        end

        local function Action_LuaScript_ConvertDetectedSurvivors()
            local _table = {}
            _table.mode = "add"
            _table.description = "LuaScript ConvertDetectedSurvivors"
            _table.type = "LuaScript"
            _table.ScriptText = LuaScript_ConvertDetectedSurvivors:gsub("\n    ", "\r\n")
            return _table
        end

        local function Action_LuaScript_SARSurvivorReachedBaseAsCargo()
            local _table = {}
            _table.mode = "add"
            _table.description = "LuaScript SARSurvivorReachedBaseAsCargo"
            _table.type = "LuaScript"
            _table.ScriptText = LuaScript_SARSurvivorReachedBaseAsCargo:gsub("\n    ", "\r\n")
            return _table
        end
    --<<//ACTIONS>>--
----------------------------------------------------------------------------------------
--<<//Individual Event/Trigger/Condition/Action/SpecialActions>>--




--<<Event Related Functions>>--
----------------------------------------------------------------------------------------
    local function AddEventTrigger(_event, _trigger)
        local function get_TriggerInfo()
            
            --for UnitDestroyed
            if _trigger.triggers.UnitDestroyed ~=nil then
                return _trigger.triggers.UnitDestroyed.ID, _trigger.triggers.UnitDestroyed.Description
            
            --for UnitDetected
            elseif _trigger.triggers.UnitDetected ~=nil then
                return _trigger.triggers.UnitDetected.ID, _trigger.triggers.UnitDetected.Description
            
            --for ScenLoaded
            elseif _trigger.triggers.ScenLoaded ~=nil then
                return _trigger.triggers.ScenLoaded.ID, _trigger.triggers.ScenLoaded.Description
            
            --for UnitBaseStatus
            elseif _trigger.triggers.UnitBaseStatus ~=nil then
                return _trigger.triggers.UnitBaseStatus.ID, _trigger.triggers.UnitBaseStatus.Description
            end
        end
        
        _trigger.guid, _trigger.description = get_TriggerInfo()
        
        local _table = {}
        _table.mode = "add"
        _table.description = _trigger.guid
        ScenEdit_SetEventTrigger(_event.guid, _table)
    end

    local function AddEventCondition(_event, _condition)
        local function get_ConditionInfo()

            --for LuaScript
            if _condition.conditions.LuaScript~=nil then
                return _condition.conditions.LuaScript.ID, _condition.conditions.LuaScript.Description
            end
        end
        
        _condition.guid, _condition.description = get_ConditionInfo()
        
        local _table = {}
        _table["mode"] = "add"
        _table["description"] = _condition.guid
        ScenEdit_SetEventCondition(_event.guid, _table)
    end
    
    local function AddEventAction(_event, _action)

        local function get_ActionInfo()
            if _action.actions.LuaScript ~=nil then
                return _action.actions.LuaScript.ID, _action.actions.LuaScript.Description
            end
        end
        
        _action.guid, _action.description = get_ActionInfo()
        
        local _table = {}
        _table["mode"] = "add"
        _table["description"] = _action.guid
        ScenEdit_SetEventAction(_event.guid, _table)
        end
----------------------------------------------------------------------------------------
--<<//Event Related Functions>>--






--<<Pakage Related Functions>>--
----------------------------------------------------------------------------------------
local function AddTo_PackageComponents_CMOT_SAR(componentType, componentGuid)
    table.insert(componentType, componentGuid)
    
    KeyStore_SetTable("PackageComponents_CMOT_SAR", PackageComponents_CMOT_SAR)
end

local function AddTo_DependantPackageComponents_CMOT_SAR(_guidDependantComponent, _componentTypeDependentComponent, _keystorekey, _guidCommonComponent)
    local _table = {}
    _table.guidDependantComponent = _guidDependantComponent
    _table.componentTypeDependentComponent = _componentTypeDependentComponent
    _table.guidCommonComponent = _guidCommonComponent
    _table.keystorekey = _keystorekey
    table.insert(DependantPackageComponents_CMOT_SAR, _table)

    KeyStore_SetTable("DependantPackageComponents_CMOT_SAR", DependantPackageComponents_CMOT_SAR)
end
----------------------------------------------------------------------------------------
--<<//Pakage Related Functions>>--



--<<Binding the Objects>>--
    --<<SHARED COMPONENTS>>--
        -- Create Event "CMOTScenarioLoaded" only if it has does not exist yet
            local _event
            if ScenEdit_GetKeyValue("EventGuid_CMOT_ScenarioLoaded")=="" then       --if Event does not exist
                _event = ScenEdit_SetEvent("CMOTScenarioLoaded", Event_CMOT_ScenarioLoaded())
                ScenEdit_SetKeyValue("EventGuid_CMOT_ScenarioLoaded",_event.guid)
                EventGuid_CMOT_ScenarioLoaded = ScenEdit_GetKeyValue("EventGuid_CMOT_ScenarioLoaded")
            else
                _event = ScenEdit_GetEvent(EventGuid_CMOT_ScenarioLoaded)
            end
            
            -- Create Trigger "CMOTScenarioLoaded" only if it doesn't not currently exist
                if ScenEdit_GetKeyValue("TriggerGuid_CMOT_ScenarioLoaded") == "" then
                    local _trigger = ScenEdit_SetTrigger(Trigger_CMOT_ScenarioLoaded())
                    ScenEdit_SetKeyValue("TriggerGuid_CMOT_ScenarioLoaded", _trigger.triggers.ScenLoaded.ID)
                    TriggerGuid_CMOT_ScenarioLoaded = ScenEdit_GetKeyValue("TriggerGuid_CMOT_ScenarioLoaded")
                    
                    AddEventTrigger(_event, _trigger)
                end
            
            -- Add CMOT Utilities Scripts:
                -- Create Action "CMOT BetterKeyStore" if it does not currently exist
                if ScenEdit_GetKeyValue("ActionGuid_CMOT_BetterKeyStore")=="" then
                    local _action = ScenEdit_SetAction(Action_LuaScript_CMOTBetterKeyStore())
                    ScenEdit_SetKeyValue("ActionGuid_CMOT_BetterKeyStore", _action.actions.LuaScript.ID)
                    ActionGuid_CMOT_BetterKeyStore = ScenEdit_GetKeyValue("ActionGuid_CMOT_BetterKeyStore")
                    
                    AddEventAction(_event, _action)
                end
            
            -- Add Script to import keys related to CMOT_SAR_Aircraft
                local _action = ScenEdit_SetAction(Action_LuaScript_CMOT_SAR_Aircraft_GetKeys())
                AddEventAction(_event, _action)
                ScenEdit_SetKeyValue("ActionGuid_CMOT_SAR_Aircraft_GetKeys", _action.guid)
                AddTo_DependantPackageComponents_CMOT_SAR(_action.guid, "action", "ActionGuid_CMOT_SAR_Aircraft_GetKeys", _event.guid)

        --Events for Periodic Events
            --Create Event "CMOT_PeriodicEvent_5Min"
                --Action
                    --Action Name: LuaScript CMOT_SAR_Aircraft_JunkCleanup
                    --Script: "JunkCleanup.lua"
    --<<//SHARED COMPONENTS>>--



    --<<INDEPENDENT COMPONENTS>>--
        -- Create Event "CMOT_SAR_Aircraft_UnitCreationUponDestruction"
                local _event = ScenEdit_SetEvent("CMOT_SAR_Aircraft UnitCreationUponDestruction", Event_CMOT_SAR_Aircraft_UnitCreationUponDestruction())
                AddTo_PackageComponents_CMOT_SAR(PackageComponents_CMOT_SAR.Events, _event.guid)

                --Create Trigger "UnitIsDestroyed PlayerAircraft"
                local _trigger = ScenEdit_SetTrigger(Trigger_UnitIsDestroyed_PlayerAircraft())
                AddEventTrigger(_event, _trigger)
                AddTo_PackageComponents_CMOT_SAR(PackageComponents_CMOT_SAR.Triggers, _trigger.guid)
                
                --Create Action "UnitCreationUponDestruction"
                local _action = ScenEdit_SetAction(Action_LuaScript_UnitCreationUponDestruction())
                AddEventAction(_event, _action)
                AddTo_PackageComponents_CMOT_SAR(PackageComponents_CMOT_SAR.Actions, _action.guid)
        
        -- Create Event "CMOT_SAR_Aircraft SARSurvivorIsFound"
            local _event = ScenEdit_SetEvent("CMOT_SAR_Aircraft SARSurvivorIsFound", Event_CMOT_SAR_Aircraft_SARSurvivorIsFound())
            AddTo_PackageComponents_CMOT_SAR(PackageComponents_CMOT_SAR.Events, _event.guid)
                --Create Trigger "UnitIsDetected SARSurvivor_MobilePersonnel"
                local _trigger = ScenEdit_SetTrigger(Trigger_UnitIsDetected_SARSurvivor_MobilePersonnel())
                AddEventTrigger(_event, _trigger)
                AddTo_PackageComponents_CMOT_SAR(PackageComponents_CMOT_SAR.Triggers, _trigger.guid)

                --Create Condition "LuaScript IsContactASurvivor"
                local _condition = ScenEdit_SetCondition(Condition_LuaScript_IsContactASurvivor())
                AddEventCondition(_event, _condition)
                AddTo_PackageComponents_CMOT_SAR(PackageComponents_CMOT_SAR.Conditions, _condition.guid)

                --Create Action "LuaScript ConvertDetectedSurvivors"
                local _action = ScenEdit_SetAction(Action_LuaScript_ConvertDetectedSurvivors())
                AddEventAction(_event, _action)
                AddTo_PackageComponents_CMOT_SAR(PackageComponents_CMOT_SAR.Actions, _action.guid)
        
        -- Create Event "CMOT_SAR_Aircraft SARSurvivorReachedBase"
            local _event = ScenEdit_SetEvent("CMOT_SAR_Aircraft SARSurvivorReachedBase", Event_CMOT_SAR_Aircraft_SARSurvivorReachedBase())
            AddTo_PackageComponents_CMOT_SAR(PackageComponents_CMOT_SAR.Events, _event.guid)
                --Create Trigger "UnitBaseStatus PlayerAircraftLandedPostTouchdown"
                local _trigger = ScenEdit_SetTrigger(Trigger_UnitBaseStatus_PlayerAircraftLandedPostTouchdown())
                AddEventTrigger(_event, _trigger)
                AddTo_PackageComponents_CMOT_SAR(PackageComponents_CMOT_SAR.Triggers, _trigger.guid)

                --Create Action "LuaScript SARSurvivorReachedBaseAsCargo"
                local _action = ScenEdit_SetAction(Action_LuaScript_SARSurvivorReachedBaseAsCargo())
                AddEventAction(_event, _action)
                AddTo_PackageComponents_CMOT_SAR(PackageComponents_CMOT_SAR.Actions, _action.guid)
    --<<//INDEPENDENT COMPONENTS>>--
end









--<<Input from User>>--
    local function CMOT_SAR_InitialInput()
        --local functions
            --Clear keys from keystore
                local function ClearPackage_CMOT_SAR()
                    -- Unbind dependant components from common components
                        local function Clear_DependentComponents_CMOT_SAR()
                            -- if there are no dependant components
                                if ScenEdit_GetKeyValue("DependantPackageComponents_CMOT_SAR") == "" then return end

                            -- unbind, and then remove any dependant pacage components
                                for k, v in pairs(DependantPackageComponents_CMOT_SAR) do
                                    local _tableUnbind = {}
                                    _tableUnbind.mode = "remove"
                                    _tableUnbind.description = v.guidDependantComponent
                                
                                    local _tableDelete = {}
                                    _tableDelete.mode = "remove"
                                    _tableDelete.description = v.guidDependantComponent
                                    
                                    if v.componentTypeDependentComponent == "action" then
                                        -- unbinds
                                        ScenEdit_SetEventAction(v.guidCommonComponent, _tableUnbind)
                                        
                                        -- removes
                                        ScenEdit_SetAction(_tableDelete)
                                        ScenEdit_ClearKeyValue(v.keystorekey)
                                    end
                                end 
                                ScenEdit_ClearKeyValue("DependantPackageComponents_CMOT_SAR")
                        end
                    
                    --Functions to properly clear package keys
                        local function Clear_PackageComponents_CMOT_SAR()
                            -- if the pakage has not initiated any components
                                if ScenEdit_GetKeyValue("PackageComponents_CMOT_SAR")=="" then return end
                            
                            --Get Size
                            local size = 0
                            for k, v in pairs(PackageComponents_CMOT_SAR) do
                                size = size + 1
                            end

                            -- for every component of the package
                            for iteration=1, size do
                                for Type, v in pairs(PackageComponents_CMOT_SAR) do
                                    local _table = {}
                                    _table.mode = "remove"
                                    
                                    
                                    --Events
                                    --Events doesn't Account for events related to "ScenarioLoaded", "ScenarioEnded" and "RegularTime"
                                    if iteration==1 and Type == "Events" then
                                        for k, Event_Guid in pairs(v) do
                                            ScenEdit_SetEvent(Event_Guid, _table)
                                        end
                                    
                                    --Triggers
                                    elseif iteration==2 and Type == "Triggers" then
                                        for k, Trigger_Guid in pairs(v) do
                                            _table.description = Trigger_Guid
                                            ScenEdit_SetTrigger(_table)
                                        end
                                    
                                    --Conditions
                                    elseif iteration==3 and  Type == "Conditions" then
                                        for k, Condition_Guid in pairs(v) do
                                            _table.description = Condition_Guid
                                            ScenEdit_SetCondition(_table)
                                        end
                                    
                                    --Actions
                                    elseif iteration==4 and  Type == "Actions" then
                                        for k, Action_Guid in pairs(v) do
                                            _table.description = Action_Guid
                                            ScenEdit_SetAction(_table)
                                        end
                                    
                                    --SpecialActions
                                    elseif iteration==5 and  Type == "SpecialActions" then
                                        for k, SpecialAction_Guid in pairs(v) do
                                            --Not implemented yet
                                        end
                                    end
                                end
                            end

                            --After Event Components are removed:
                            ScenEdit_ClearKeyValue("PackageComponents_CMOT_SAR")
                        end

                    --table
                    Clear_PackageComponents_CMOT_SAR()    --For Key "PackageComponents_CMOT_SAR"
                    Clear_DependentComponents_CMOT_SAR() -- For Key "DependantPackageComponents_CMOT_SAR"
                    ScenEdit_ClearKeyValue("CMOT_SAR_Aircraft_SurvivorList")
                    ScenEdit_ClearKeyValue("CMOT_SAR_AircraftWreckageList")

                    --string
                    ScenEdit_ClearKeyValue("CMOT_SAR_PlayerSide")
                    ScenEdit_ClearKeyValue("CMOT_SAR_SARSide")
                    
                    --number
                    ScenEdit_ClearKeyValue("CMOT_SAR_AircraftWreckageLimit")
                    --CMOTPackagesCount
                end

        --Start of Function
            -- mode selection
            local button = UI_CallAdvancedDialog("Mode Selection", "Select Mode", {"Add Package", "Delete Package"})
            if button == "" then return nil end
            ClearPackage_CMOT_SAR()
            if button == "Delete Package" then return end

            local AvailableSides = {}
            for k,v in pairs(VP_GetSides()) do
                table.insert(AvailableSides, v.name)
            end


            --Input for Player SideSelection
                Text_PlayerSide = Text_PlayerSide:gsub("\n        ", "\r\n")
                local button = UI_CallAdvancedDialog("Side Selection", Text_PlayerSide, AvailableSides)
                if button == "" then return nil end
                ScenEdit_SetKeyValue("CMOT_SAR_PlayerSide", button)
                CMOT_SAR_PlayerSide = ScenEdit_GetKeyValue("CMOT_SAR_PlayerSide")
            


            --Input for SAR SideSelection
                Text_SARSide = Text_SARSide:gsub("\n        ", "\r\n")
                local button = UI_CallAdvancedDialog("Side Selection", Text_SARSide, AvailableSides)
                if button == "" then return nil end
                ScenEdit_SetKeyValue("CMOT_SAR_SARSide", button)
                CMOT_SAR_SARSide = ScenEdit_GetKeyValue("CMOT_SAR_SARSide")





            --Input for AircraftWreckageLimit
                Text_AircraftWreckageLimit = Text_AircraftWreckageLimit:gsub("\n        ", "\r\n")

                while true do
                    local input = ScenEdit_InputBox (Text_AircraftWreckageLimit)
                    if input=="" then
                        ScenEdit_MsgBox("Exiting", 1)
                        return nil
                    end
                    if tonumber(input)~=nil then    --checks for valid number
                        local integer = tonumber(input)-tonumber(input)%1   --converts possible float value to integer value
                        if integer>0 then   --checks for valid integer
                            ScenEdit_SetKeyValue("CMOT_SAR_AircraftWreckageLimit", tostring(integer))
                            CMOT_SAR_AircraftWreckageLimit = tonumber(ScenEdit_GetKeyValue("CMOT_SAR_AircraftWreckageLimit"))
                            break
                        else
                            ScenEdit_MsgBox("Must be greater than -1", 6)
                        end
                    else
                        ScenEdit_MsgBox("Must be a number", 6)
                    end
                end



            --Display Recommendation
                Text_Recommendation = Text_Recommendation:gsub("\n    ", "\r\n")
                ScenEdit_MsgBox(Text_Recommendation, 6)

            return "Done"
    end
--<<//Input from User>>--






--<<DRIVER CODE>>--
    if CMOT_SAR_InitialInput()~="Done" then
        return
    end
    CMOT_SAR_Aircraft_Init()
    Text_ReloadScenario = Text_ReloadScenario:gsub("\n    ", "\r\n")
    ScenEdit_MsgBox(Text_ReloadScenario, 6)
--<<//DRIVER CODE>>--