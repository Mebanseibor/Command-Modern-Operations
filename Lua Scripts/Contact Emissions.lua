local function print_contacts_emisions(i_contact_list)
    local function analyse_emissions(lf_emissions)
        if #lf_emissions == 0 then
            print("    -No Emission was detected")
        else
            for i=1,#lf_emissions do
                print("    -Emission of \""..lf_emissions[i].sensor_name.."\" was detected")
                print("        -Emission dbid: "..lf_emissions[i].sensor_dbid)
            end
        end
    end

    if #i_contact_list == 0 then
        print("-----No contacts-----")
        print("-----END-----")
        return -1
    end
    for i=1,#i_contact_list do
        local _contact = i_contact_list[i]
        local _emission = _contact.emissions
        local _actual_guid = _contact.actualunitid
        local _actual_name = ScenEdit_GetUnit({guid=_actual_guid}).name
        print("Actual name: "..tostring(_actual_name))
        print("Contact: ".._contact.name)
        print("Emission: ")
        analyse_emissions(_emission)
        print("    -Potential Matches: ")
        if tostring(_contact.potentialmatches)=="nil" then
            print("        None")
        else
            for i=1,#_contact.potentialmatches do
                local  _potential_type = tostring(_contact.potentialmatches[i].TYPE)
                local  _potential_name = tostring(_contact.potentialmatches[i].NAME)
                print("        Match "..i..": (".._potential_type..")\t".._potential_name)
            end
        end
        print("")
    end
    print("-----END-----")
end

print("-----START-----")
local v_side = "Blue"
local v_contact_list = ScenEdit_GetContacts(v_side)
print_contacts_emisions(v_contact_list)
print("")
print("")