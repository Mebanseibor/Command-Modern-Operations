--[[
    Scripts last updated on: (YYYY/MM/DD)
]]--


-- if (CMOT.ScenLoaded == nil) then
--     CMOT.ScenLoaded = {}
--     CMOT.ScenLoaded.countHolders = 0
--     ScenEdit_SetKeyValue("CMOT.ScenLoaded.countHolders", CMOT.ScenLoaded.countHolders)
-- end



-- creates a table "CMOT" if not defined yet
if (CMOT == nil) then
    CMOT = {}
end

-- input mode (add pack/delete pack)
local button = UI_CallAdvancedDialog("Mode Selection", "Select Mode", {"Add SAR Pack", "Delete SAR Pack"})
if button == "" then return end

if (button == "Delete SAR Pack") then
    print("Selected \"Delete SAR Pack\"")
    
    -- if SAR feature pack was never present
    if(CMOT.SAR == nil) then return end

    -- when the SAR feature pack was already present
    CMOT.SAR.packUp()
    return
end


-- when button == Add SAR Pack

-- if SAR feature pack was already present
if(CMOT.SAR ~= nil) then CMOT.SAR.packUp() end

-- if SAR feature pack was never present
if(CMOT.SAR == nil) then CMOT.SAR = {} end




function CMOT.SAR.Init()
    CMOT.SAR.component = {}
    CMOT.SAR.component.size = 0
    CMOT.SAR.component.list = {} -- Structure: {{guid = ""}}



    CMOT.SAR.dependency = {}
    CMOT.SAR.dependency.list = {}



    CMOT.SAR.keyStore = {}
    CMOT.SAR.keyStore.list = {} -- Structure: {{keyStoreValue}}
    
    
    
    CMOT.SAR.side = {}
    CMOT.SAR.side.searchAndRescue = ""
    CMOT.SAR.side.playerSide = ""



    CMOT.SAR.survivor = {}
    CMOT.SAR.survivor.list = {} -- Structure: {{survivor = guidSurvivor, marker = guidMarker}}
    function CMOT.SAR.survivor.count() return #CMOT.SAR.survivor.list end



    CMOT.SAR.text = {}
    CMOT.SAR.text.inputPlayerSide = [[]]
    CMOT.SAR.text.inputAircraftWreckageLimit = [[]]
    CMOT.SAR.text.recommendations = [[]]
    CMOT.SAR.text.reloadScenario = [[]]




    CMOT.SAR.wreckage = {}
    CMOT.SAR.wreckage.limit = 1
    CMOT.SAR.wreckage.list = {} -- Structure: {{guid = guidWreckage}}
    function CMOT.SAR.wreckage.count() return #CMOT.SAR.wreckage.list end
end
CMOT.SAR.Init()

-- text
CMOT.SAR.text.inputPlayerSide = [[
Select Player's Side
]]

CMOT.SAR.text.inputAircraftWreckageLimit = [[
Enter the maximum number of Aircraft Wreckage that can be present at a time

Purpose: This reduces the total number of unnecessary units in a scenario
]]

CMOT.SAR.text.recommendations = [[
Recommended Configuration for SAR Side:

- Set SAR side's Awareness Level to "Blind", to reduce unnecessary sensor calculations

- Set SAR side as Neutral to all sides to prevent aggression

- Set SAR side's playability as "Computer-only"
]]

CMOT.SAR.text.reloadScenario = [[
For the package to take immediate effect:
- Kindly save and then reload this scenario
]]


function CMOT.SAR.takeInput()
    local availableSides = {}

    -- get available sides in the current scenario
    function getSides()
        for k,v in pairs(VP_GetSides()) do
            table.insert(availableSides, v.name)
        end
    end
    
    -- input for selection of Player Side
    function inputPlayerSide()
        -- retrieve input text for player side
        CMOT.SAR.text.inputPlayerSide = CMOT.SAR.text.inputPlayerSide:gsub("\n        ", "\r\n")

        -- display input text for player side
        local button = UI_CallAdvancedDialog("Player Side Selection", CMOT.SAR.text.inputPlayerSide, availableSides)
        if button == "" then return -1 end
        
        -- matching the selected side name to its guid
        for k, side in pairs(VP_GetSides()) do
            if(button == side.name) then
                local guidPlayerSide = side.guid

                -- set key
                ScenEdit_SetKeyValue("CMOT.SAR.side.player", guidPlayerSide)
                CMOT.SAR.side.player = ScenEdit_GetKeyValue("CMOT.SAR.side.player")
                break
            end
        end
    end

    
    -- creates SAR
    function createSARSide()
        local sideSAR = ScenEdit_AddSide({side="CMOT SAR"})
        local guidSARSide = sideSAR.guid
        ScenEdit_SetKeyValue("CMOT.SAR.side.searchAndRescue", guidSARSide)
        CMOT.SAR.side.searchAndRescue = ScenEdit_GetKeyValue("CMOT.SAR.side.searchAndRescue")
    end

    -- input for Aircraft wreckage limit
    function setAircraftWreckageLimit()
        while true do
            CMOT.SAR.text.inputAircraftWreckageLimit = CMOT.SAR.text.inputAircraftWreckageLimit:gsub("\n        ", "\r\n")
            local input = ScenEdit_InputBox(CMOT.SAR.text.inputAircraftWreckageLimit)
            
            if input=="" then
                ScenEdit_MsgBox("Exiting package creation", 1)
                return -1
            end
            
            if tonumber(input)==nil then    -- checks if input is NOT a valid number
                ScenEdit_MsgBox("Input must be a number", 1)
            else
                local integer = tonumber(input) - tonumber(input)%1 -- converts possible float value to integer value

                if integer < 0 then -- checks if integer is a logically unacceptable number
                    ScenEdit_MsgBox("Input must be a number greater than -1", 6)
                else 
                    ScenEdit_SetKeyValue("CMOT.SAR.wreckage.limit", tostring(integer))
                    CMOT.SAR.wreckage.limit = tonumber(ScenEdit_GetKeyValue("CMOT.SAR.wreckage.limit"))
                    break
                end
            end
        end
    end

    -- display recommendations
    function displayRecommendations()
        CMOT.SAR.text.recommendations = CMOT.SAR.text.recommendations:gsub("\n    ", "\r\n")
        ScenEdit_MsgBox(CMOT.SAR.text.recommendations, 6)
    end

    getSides()
    if inputPlayerSide() == -1 then return -1 end
    createSARSide()
    if setAircraftWreckageLimit() == -1 then return -1 end
    displayRecommendations()
    return "Input completed"
end

function CMOT.SAR.buildComponents()
    -- local function bindComponent(event, component)
    
    -- CMOT.SAR.component.getKeyStores = {guid = action.guid, type = "action", CMOT.scenLoaded.event}
end

function CMOT.SAR.component.removeAll()
    for k, v in pairs(CMOT.SAR.component.list) do
    end
    
    print("Successfully removed all components for the package")
end

function CMOT.SAR.dependency.releaseAll()
    print("Successfully released all dependencies values for the package")
end

function CMOT.SAR.keyStore.clearAll()
    -- for k, v in pairs() do
    --     ScenEdit_ClearKeyValue()
    -- end

    print("Successfully cleared all keystore values for the package")
end


function CMOT.SAR.side.removeAll()
    function removeSideSAR()
        local guidSideSAR = ScenEdit_GetKeyValue("CMOT.SAR.side.searchAndRescue")
        
        -- when the sideSAR was never defined
        if (guidSideSAR == "") then return end
        
        local side = ScenEdit_RemoveSide({side = guidSideSAR})

        -- when guid exist by side does not exist
        if(side == nil) then
            local errorMsg = [[
            Error: Somehow CMOT.SAR.side.searchAndRescue is present...
            ...but cannot retrieve side by using guid
            ]]
            print(errorMsg)
            ScenEdit_MsgBox(errorMsg, 6)
            return
        end
        
        print("Successfully removed side \"" .. side.name .."\"")
    end

    removeSideSAR()
    print("Successfully removed all extra sides for the package")
end

function CMOT.SAR.packUp()
    CMOT.SAR.side.removeAll()
    CMOT.SAR.component.removeAll()
    CMOT.SAR.dependency.releaseAll()
    CMOT.SAR.keyStore.clearAll()
    CMOT.SAR = nil
end



print("Taking input")
-- ends the creation of the package if the input was not fully completed
if CMOT.SAR.takeInput() ~= "Input completed" then
    CMOT.SAR.packUp()
    return
end

CMOT.SAR.buildComponents()

-- request a formal restart/reload to the scenario for immediate effect of the package
CMOT.SAR.text.reloadScenario = CMOT.SAR.text.reloadScenario:gsub("\n    ", "\r\n")
ScenEdit_MsgBox(CMOT.SAR.text.reloadScenario, 6)

print("Package was successfully added")
-------------------------