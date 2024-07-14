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