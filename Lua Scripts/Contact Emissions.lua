local function print_contacts_emisions(i_contact_list)
    --Local Functions--
    local function is_table_empty(lf_table)
        if lf_table==nil or #lf_table == 0 then return true
        else return false end
    end
    local function print_emissions(lf_emissions)
        if is_table_empty(lf_emissions) then
            print("    -No Emission was detected")
        else
            for k,_emission in pairs(lf_emissions) do
                print("    -Emission of \"".._emission.sensor_name.."\" was detected")
                print("        -Emission dbid: ".._emission.sensor_dbid)
            end
        end
    end
    local function print_potential_matches(lf_contact)
        if lf_contact.potentialmatches==nil or #(lf_contact.potentialmatches)==0 then
            print("    None")
        else
            if lf_contact.classificationlevel==3 then
                print("Confirmed Match: "..string.sub(lf_contact.type_description,8))
                --substring is used to cut off the "class" string that is printing
                return
            end
            print("Potential Matches: ")
            local _potential_match_count = 0
            for k,_potentialmatch in pairs(lf_contact.potentialmatches)do
                _potential_match_count = _potential_match_count+1
                local  _potential_type = tostring(_potentialmatch.TYPE)
                local  _potential_name = tostring(_potentialmatch.NAME)
                print("    -Match ".._potential_match_count..": (".._potential_type..")\t".._potential_name)
            end
        end
    end

    --Function Body--
    if is_table_empty(i_contact_list) then
        print("-----No contacts-----")
        return -1
    end
    for k,_contact in pairs(i_contact_list) do
        local _emission = _contact.emissions
        local _actual_guid = _contact.actualunitid
        local _actual_name = ScenEdit_GetUnit({guid=_actual_guid}).name
        print("Actual name: "..tostring(_actual_name))
        print("Contact: ".._contact.name)
        print("Emission: ")
        print_emissions(_emission)
        print_potential_matches(_contact)
        print("")
    end
end

print("-----START-----")
local v_side = "Blue"
local v_contact_list = ScenEdit_GetContacts(v_side)
print_contacts_emisions(v_contact_list)
print("-----END-----")
print("")
print("")