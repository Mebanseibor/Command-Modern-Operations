CMOT = {}
CMOT.ScenLoaded = {}
CMOT.ScenLoaded.countHolders = tonumber(ScenEdit_GetKeyValue("CMOT.ScenLoaded.countHolders"))

CMOT.SAR.component = {}
function CMOT.SAR.component.count() return #CMOT.SAR.component end
CMOT.SAR.component.getKeyStores = KeyStore_GetTable("CMOT.SAR.component.getKeyStores")



CMOT.SAR = {}
CMOT.SAR.side = {}
CMOT.SAR.side.searchAndRescue = ScenEdit_GetKeyValue("CMOT.SAR.side.searchAndRescue")
CMOT.SAR.side.playerSide = ScenEdit_GetKeyValue("CMOT.SAR.side.player")



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