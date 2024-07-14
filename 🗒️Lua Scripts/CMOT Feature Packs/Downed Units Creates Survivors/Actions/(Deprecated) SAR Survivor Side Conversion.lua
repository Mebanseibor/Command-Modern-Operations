local marker = ScenEdit_UnitX()
local _guid = marker.guid

local function ConvertUnit(_guid)
    local survivor = ScenEdit_GetUnit({guid=_guid})
    ScenEdit_SetUnitSide ({guid=_guid, newSide=CMOT_SAR_PlayerSide})
    survivor.SAR_enabled = true
end

for k,v in pairs(CMOT_SAR_Aircraft) do
    if v.marker == _guid then
        ConvertUnit(v.survivor)
    end
end