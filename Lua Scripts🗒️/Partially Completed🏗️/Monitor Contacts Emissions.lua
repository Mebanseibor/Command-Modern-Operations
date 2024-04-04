function monitor_contacts_emissions(i_side)
    local function analyse_emission(_contact)
        if _contact.emissions == nil then
            print("No Emission")
            return
        end
        for k, _emission in pairs(_contact.emissions) do
           print("Emission of \"".._emission.name.."\" of dbid ".._emission.sensor_dbid)
            if _emission.sensor_dbid==970 then
                _contact.observer_posture = "N"
            else
                _contact.observer_posture = "H"
            end
        end
    end
    local _contact_list = ScenEdit_GetContacts(i_side)
    for k,_contact in pairs(_contact_list) do
        print("Name: "..ScenEdit_GetUnit({guid = _contact.actualunitid}).name)
        analyse_emission(_contact)
        print("Posture: ".._contact.observer_posture)
        print("\n\n")
    end
    
end
print("-----START-----")
local v_side = "Blue"
monitor_contacts_emissions(v_side)
print("-----END-----")
print("")
print("")