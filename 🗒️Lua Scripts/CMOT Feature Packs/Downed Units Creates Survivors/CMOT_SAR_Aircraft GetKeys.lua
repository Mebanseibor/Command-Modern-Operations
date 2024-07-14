
--Functions
    -- KeyStore_SetTable(name, table, forCampaign)
    -- KeyStore_GetTable(name)

--Special Considerations
    --For ScenarioLoaded
        TriggerGuid_CMOT_ScenarioLoaded  = ScenEdit_GetKeyValue("TriggerGuid_CMOT_ScenarioLoaded")
        -- CMOT Utilities Scripts:
            ActionGuid_CMOT_BetterKeyStore = ScenEdit_GetKeyValue("ActionGuid_CMOT_BetterKeyStore")
        -- For importing this script
            --ActionGuid_CMOT_SAR_Aircraft_GetKeys = ScenEdit_GetKeyValue("ActionGuid_CMOT_SAR_Aircraft_GetKeys")   <--Unbinding this Action from its Event is not implemented yet


--table
PackageComponents_CMOT_SAR = KeyStore_GetTable("PackageComponents_CMOT_SAR")
CMOT_SAR_Aircraft_SurvivorList = KeyStore_GetTable("CMOT_SAR_Aircraft_SurvivorList")
CMOT_SAR_AircraftWreckageList = KeyStore_GetTable("CMOT_SAR_AircraftWreckageList")
--CMOT_SAR_EventsGuid = 


--string
CMOT_SAR_PlayerSide = ScenEdit_GetKeyValue("CMOT_SAR_PlayerSide")
CMOT_SAR_SARSide = ScenEdit_GetKeyValue("CMOT_SAR_SARSide")



--number
CMOT_SAR_AircraftWreckageLimit = tonumber(ScenEdit_GetKeyValue("CMOT_SAR_AircraftWreckageLimit"))
--CMOTPackagesCount = tonumber(ScenEdit_GetKeyValue("CMOTPackagesCount"))