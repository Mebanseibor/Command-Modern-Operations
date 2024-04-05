-----GENERAL UTILITY FUNCTIONS-----
local function is_table_empty(data)
    if data==nil or #data == 0 then return true
    else return false end
end
-----------------------------------

local function display_contacts_emisions(i_contact_list)

    local function print_emissions(lf_contact)
        print("Emission: ")
        local _emissions = lf_contact.emissions
        if is_table_empty(_emissions) then
            print("    -No Emission was detected")
        else
            for k,_emission in pairs(_emissions) do
                print("    -Emission of \"".._emission.sensor_name.."\" was detected (dbid: ".._emission.sensor_dbid..")")
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
                print("    -Match ".._potential_match_count..":\t"..string.sub(_potential_type,1,3).."\t".._potential_name)
            end
        end
    end

    --Function Body--
    if is_table_empty(i_contact_list) then
        print("-----No contacts-----")
        return -1
    end
    for k,_contact in pairs(i_contact_list) do
        local _actual_guid = _contact.actualunitid
        local _actual_name = ScenEdit_GetUnit({guid=_actual_guid}).name
        print("Actual name: "..tostring(_actual_name))
        print("Contact: ".._contact.name)
        print_emissions(_contact)
        print_potential_matches(_contact)
        print("")
    end
end

display_contacts_emisions(ScenEdit_GetContacts(ScenEdit_PlayerSide))