local function check_for_emisions(i_contact_list)
    if #i_contact_list == 0 then
        print("-----No contacts-----")
        print("-----END-----")
        return -1
    end
    for i=1,#i_contact_list do
        local _contact = i_contact_list[i]
        local _emission = _contact.emissions
        if _emission==nil then _emission = "nil" end
        local _actual_guid = _contact.actualunitid
        local _actual_name = ScenEdit_GetUnit({guid=_actual_guid}).name
        print("Actual name: "..tostring(_actual_name))
        print("Contact: ".._contact.name)
        print("Emission: ")

        local conclusion = "Unknown"
        if #_emission == 0 then
            print("    -No Emission was detected")
        else
            for i=1,#_emission do
                print("    -Emission of \"".._emission[i].sensor_name.."\" was detected")
                print("        -Emission dbid: ".._emission[i].sensor_dbid)
                if(_emission[i].sensor_dbid == 970)then
                    conclusion = "Friendly"
                    --n=nuetral, x=nuetral, h=hostile, f=friendly, u=unfirendly
                    break
                end
            end
        end
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
        print(conclusion)
        print("")
    end
    print("-----END-----")
end

print("-----START-----")
local v_side = "Blue"
local v_contact_list = ScenEdit_GetContacts(v_side)
check_for_emisions(v_contact_list)
print("")
print("")