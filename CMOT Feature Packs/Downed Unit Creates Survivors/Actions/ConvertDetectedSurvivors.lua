local _unitContact = ScenEdit_UnitC()

local _table = {}
_table.guid = _unitContact.actualunitid
_table.newSide = CMOT_SAR_PlayerSide
ScenEdit_SetUnitSide (_table)

ScenEdit_MsgBox("Survivor Found", 6)