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