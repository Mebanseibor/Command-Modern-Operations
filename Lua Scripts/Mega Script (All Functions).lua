--[[
Identifier/variables prefix meanings:
    v: variables (global)
    i: input
    _: local to function only


Functions:
        Contact:
            is_any_contact_in_area(side, area)
        EMCON:
            set_radar_state(guid,<0/1>)
            flip_radar_state(guid)
        Unit Group:
            is_subtype_in_unitlist(unit_group,subtype_number)
        Zone:
            get_zone_rp_names(side, zone_name)
            get_units_in_area(side , area)
]]--

----- Contact -----
function is_any_contact_in_area(i_side, i_area)
    local _contact_list = ScenEdit_GetContacts(i_side)
    for i=1,#_contact_list do
        local _contact_actual_guid = _contact_list[i].actualunitid
        local _contact_as_unit = ScenEdit_GetUnit({guid = _contact_actual_guid})

        if(_contact_as_unit:inArea(i_area)) then
            return true
        end
    end
    return false
end

----- EMCON -----
function set_radar_state(i_unit_guid,i_radar_state)
    local _state_table = {[0]="Passive", [1]="Active"} 
    ScenEdit_SetEMCON("Unit" , i_unit_guid , "Radar="..state_table[i_radar_state]) 
    return
end

function flip_radar_state(i_unit_guid)
    local _from_state = ScenEdit_GetDoctrine({guid=i_unit_guid,actual=true}).emcon.radar
    
    if(tostring(_from_state)==tostring(0)) then to_state="Active"
    else _to_state="Passive" end
    
    ScenEdit_SetEMCON("Unit" , i_unit_guid , "Radar=".._to_state)
    return
end



----- Unit Group -----
function is_subtype_in_unitlist(i_unit_list,i_subtype)
    for i=1,#i_unit_list do
        local _subtype = ScenEdit_GetUnit({guid=i_unit_list[i].guid}).subtype
        if(_subtype == tostring(i_subtype))then
            return true
        end
    end
    return false
end

----- Zone -----
function get_zone_rp_names(i_side, i_zone_name)
    local _zone = VP_GetSide({side=i_side}):getstandardzone(i_zone_name)
    local _zone_area = _zone.area
    local _zone_rp = {}
    for i=1,#_zone_area do
        table.insert(_zone_rp,_zone_area[i].name)
    end
    return _zone_rp
end

function get_units_in_area(i_side , i_area)
    -- Extensions: TargetFilter={TargetType="Aircraft"}
    local _unit_list = VP_GetSide({side=i_side}):unitsInArea({Area=i_area})
    return _unit_list
end





----- Arguments -----
local v_side = "Blue"
local v_unit_guid = ""
local v_radar_state = ""
local v_zone_name = "Over Guwahati"

----- To do -----