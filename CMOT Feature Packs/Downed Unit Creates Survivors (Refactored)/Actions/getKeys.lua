CMOT = {}
CMOT.ScenLoaded = {}
CMOT.ScenLoaded.countHolders = tonumber(ScenEdit_GetKeyValue("CMOT.ScenLoaded.countHolders"))


CMOT.SAR = {}
CMOT.SAR.component = {}
function CMOT.SAR.component.count() return #CMOT.SAR.component end
CMOT.SAR.component.getKeyStores = KeyStore_GetTable("CMOT.SAR.component.getKeyStores")
CMOT.SAR.component.list = KeyStore_GetTable("CMOT.SAR.component.list")



CMOT.SAR.dependency = {}
CMOT.SAR.dependency.list = KeyStore_GetTable("CMOT.SAR.dependency.list")



CMOT.SAR.keyStore = {}
CMOT.SAR.keyStore.list = KeyStore_GetTable("CMOT.SAR.keyStore.list")    -- Structure: {{keyStoreValue}}



CMOT.SAR.side = {}
CMOT.SAR.side.searchAndRescue = ScenEdit_GetKeyValue("CMOT.SAR.side.searchAndRescue")   -- stores the GUID of the SAR side
CMOT.SAR.side.playerSide = ScenEdit_GetKeyValue("CMOT.SAR.side.player") -- stores the GUID of the Player side



CMOT.SAR.survivor = {}
CMOT.SAR.survivor.list = KeyStore_GetTable("CMOT.SAR.survivor.list")
function CMOT.SAR.survivor.count() return #CMOT.SAR.survivor.list end



CMOT.SAR.wreckage = {}
CMOT.SAR.wreckage.limit = tonumber(ScenEdit_GetKeyValue("CMOT.SAR.wreckage.limit"))
    -- checks for when limit is accidentally negative
    if(CMOT.SAR.wreckage.limit == nil) then
        CMOT.SAR.wreckage.limit = 1
        ScenEdit_SetKeyValue("CMOT.SAR.wreckage.limit", 1)
    end
CMOT.SAR.wreckage.list = KeyStore_GetTable("CMO.SAR.survivor.list")
function CMOT.SAR.wreckage.count() return #CMOT.SAR.wreckage.list end



-- [#Tracking]  functions to keep updating to any changes
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