--Issues

local _unitCargoPicker = ScenEdit_UnitX()
local _unitCargo = _unitCargoPicker.pickUpTarget
ScenEdit_DeleteUnit(_unitCargo, false)
ScenEdit_MsgBox("Survivor was Rescued", 6)