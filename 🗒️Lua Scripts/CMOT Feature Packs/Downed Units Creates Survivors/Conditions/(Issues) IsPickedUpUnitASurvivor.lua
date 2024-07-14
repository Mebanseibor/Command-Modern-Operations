local _unitCargoPicker = ScenEdit_UnitX()
local _unitCargo = _unitCargoPicker.pickUpTarget



-- Checks if a Cargo is a Survivor?
for k, v in pairs(CMOT_SAR_Aircraft) do
    if _unitCargo.guid == v.survivor then
        ScenEdit_MsgBox("Survivor Picked Up!!!", 6)
        return true
    end
end

return false