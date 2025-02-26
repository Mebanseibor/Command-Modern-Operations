--[[
    Scripts last updated on: (YYYY/MM/DD)
]]--


-- if (CMOT.ScenLoaded == nil) then
--     CMOT.ScenLoaded = {}
--     CMOT.ScenLoaded.countHolders = 0
--     ScenEdit_SetKeyValue("CMOT.ScenLoaded.countHolders", CMOT.ScenLoaded.countHolders)
-- end






function CMOT.SAR.Init()
    CMOT.SAR.component = {}
    CMOT.SAR.component.size = 0
    CMOT.SAR.component.list = {} -- Structure: {{guid = ""}}



    CMOT.SAR.dependency = {}
    CMOT.SAR.dependency.list = {}



    CMOT.SAR.keyStore = {}
    CMOT.SAR.keyStore.list = {} -- Structure: {{keyStoreValue}}
    CMOT.SAR.keyStore.clearAll()
    
    
    
    CMOT.SAR.side = {}
    CMOT.SAR.side.searchAndRescue = ""
    CMOT.SAR.side.playerSide = ""


    CMOT.SAR.survivor = {}
    CMOT.SAR.survivor.list = {} -- Structure: {{survivor = guidSurvivor, marker = guidMarker}}
    function CMOT.SAR.survivor.count() return #CMOT.SAR.survivor.list end


    
    CMOT.SAR.wreckage = {}
    CMOT.SAR.wreckage.limit = 1
    CMOT.SAR.wreckage.list = {} -- Strucutre: {{guid = guidWreckage}}
    function CMOT.SAR.wreckage.count() return #CMOT.SAR.wreckage.list end
end



function CMOT.SAR.component.removeAll()
    for k, v in pairs(CMOT.SAR.component.list) do
        
    end
end

function CMOT.SAR.dependency.releaseAll()
end

function CMOT.SAR.keyStore.clearAll()
    -- for k, v in pairs() do
    --     ScenEdit_ClearKeyValue()
    -- end
end


function CMOT.SAR.takeInput()
    --Input for selection of Player Side
    CMOT.SAR.text.inputPlayerSide = CMOT.SAR.text.inputPlayerSide:gsub("\n        ", "\r\n")
    local button = UI_CallAdvancedDialog("Side Selection", Text_PlayerSide, AvailableSides)
    if button == "" then return nil end
    ScenEdit_SetKeyValue("CMOT_SAR_PlayerSide", button)
    CMOT_SAR_PlayerSide = ScenEdit_GetKeyValue("CMOT_SAR_PlayerSide")
end

function CMOT.SAR.buildComponents()
    -- local function bindComponent(event, component)
    
    -- CMOT.SAR.component.getKeyStores = {guid = action.guid, type = "action", CMOT.scenLoaded.event}
    

end





-----<<DRIVER CODE>>-----

if (CMOT == nil) then
    CMOT = {}
end


-- input mode (add pack/delete pack)
local button = UI_CallAdvancedDialog("Mode Selection", "Select Mode", {"Add SAR Pack", "Delete SAR Pack"})
if button == "" then return end




-- if SAR feature pack was never present
if (button == "Delete SAR Pack" and CMOT.SAR == nil) then return end

CMOT.SAR.component.removeAll()
CMOT.SAR.dependency.releaseAll()
CMOT.SAR.keyStore.clearAll()
CMOT.SAR = nil

if button == "Delete SAR Pack" then
    -- is it just better to define the functionallity of "CMOT.packUp" here by itself?
    return
end


CMOT.SAR.Init()
CMOT.SAR.TakeInput()
-------------------------