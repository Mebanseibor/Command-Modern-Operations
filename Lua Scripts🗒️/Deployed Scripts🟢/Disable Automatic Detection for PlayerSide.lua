local sideObj = VP_GetSide({side=ScenEdit_PlayerSide()})
local unitsList = sideObj.units
for k, v in pairs(unitsList) do
    ScenEdit_SetUnit({guid=v.guid, autodetectable=false})
end