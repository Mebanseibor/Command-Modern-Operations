local function CleanUp_CMOT_SAR_Aircraft_SurvivorList()
    for k, v in pairs(CMOT_SAR_Aircraft_SurvivorList) do
        local _unitSurvivor = ScenEdit_GetUnit({guid=v.survivor})
        local _unitMarker = ScenEdit_GetUnit({guid=v.marker})
        --if Survivor no longer exist
        if _unitSurvivor==nil then
            
            -- if Marker exist
            if _unitMarker~=nil then
                --Delete Marker
                    ScenEdit_DeleteUnit({guid=v.marker}, false)
            
            --if Marker doesn't exist
            else
                --Removing both Survivor's and Marker's Info
                CMOT_SAR_Aircraft_SurvivorList[k] = nil
                --Update Surivor Table
                KeyStore_SetTable("CMOT_SAR_Aircraft_SurvivorList", CMOT_SAR_Aircraft_SurvivorList)
            end
                    
        --if Survivor still exist
        else
            --if Marker exist
            if _unitMarker~=nil then
                local SeperationThreshold = 2   --in nm
                --if Survivor is far from its marker by distance of <SeperationThreshold>
                if Tool_Range(v.survivor, v.marker)>=SeperationThreshold then
                    --Delete Marker
                     ScenEdit_DeleteUnit({guid=v.marker}, false)

                    --Removing only the Marker's Info
                        CMOT_SAR_Aircraft_SurvivorList[k].marker = nil
                    --Update Surivor Table
                        KeyStore_SetTable("CMOT_SAR_Aircraft_SurvivorList", CMOT_SAR_Aircraft_SurvivorList)
                end
            end
        end
    end
end

--<<Initialization>>--
CleanUp_CMOT_SAR_Aircraft_SurvivorList()