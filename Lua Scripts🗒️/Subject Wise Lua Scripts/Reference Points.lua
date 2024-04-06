--[[
    Functions:
        add_trailing_rp(Unit, distance) --Parameters(Unit,int)
]]--

local function add_trailing_rp(_unit,i_distance)
    local _bearing=(_unit.heading+180) % 360
    local _bearingtype = 1 --(0|1) (Fixed|Relative)
    local _color="orange"
    local _distance=i_distance
    local _name="TP-".._unit.name
    local _relativeto = _unit.guid
    local _side = ScenEdit_PlayerSide()
    ScenEdit_AddReferencePoint ({bearing=_bearing, bearingtype=_bearingtype, color=_color, distance=_distance, name=_name, relativeto=_relativeto,side=_side})
end