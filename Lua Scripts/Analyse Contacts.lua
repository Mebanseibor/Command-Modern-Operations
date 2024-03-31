function analyse_contacts(i_side)
        local function is_table_empty(lf_table)
            if #lf_table==0 then return true
            else return false end
        end
        local function print_contact_info(lf_contact)
            print("Contact Name: "..lf_contact.name)
            print("Contact Observer Posture: "..lf_contact.observer_posture)
            print("Contact Type: "..tostring(lf_contact.type))
            print("Contact Type Description: "..tostring(lf_contact.type_description))
            print("Contact Speed: "..tostring(lf_contact.speed).." knots")
            print("Contact Altitude: "..tostring(lf_contact.altitude).." meters")
            print("Contact Last Detected age: "..tostring(lf_contact.lastDetections[1].age).." seconds ago")
            print("Contact Classification  Level: "..tostring(lf_contact.classificationlevel))
            print("Contact Filter Out: "..tostring(lf_contact.FilterOut))
            print("")
        end
        local _contacts_list = ScenEdit_GetContacts(i_side)
        if is_table_empty(_contacts_list) then
            print("No Contacts")
            return
        else
            for k,_contact in pairs(_contacts_list) do
                print_contact_info(_contact)
            end
        end
end
print("-----START-----")
local v_side = "Blue"
analyse_contacts(v_side)
print("-----END-----")
print("")
print("")