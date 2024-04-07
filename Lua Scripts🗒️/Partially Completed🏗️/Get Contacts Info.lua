function get_contacts_info(_side)
    local function print_contact_info(_contact)
        print("Contact Name: ".._contact.name)
        print("Contact Observer Posture: ".._contact.observer_posture)
        print("Contact Type: "..tostring(_contact.type))
        print("Contact Type Description: "..tostring(_contact.type_description))
        print("Contact Speed: "..tostring(_contact.speed).." knots")
        print("Contact Altitude: "..tostring(_contact.altitude).." meters")
        print("Contact Last Detected age: "..tostring(_contact.lastDetections[1].age).." seconds ago")
        print("Contact Classification  Level: "..tostring(_contact.classificationlevel))
        print("Contact Filter Out: "..tostring(_contact.FilterOut))
        print("")
    end
    local function display_contact_info(_contact)
        local info = {}
        info["name"] = _contact.name
        info["posture"] = convert_contact_posture(_contact.observer_posture)
        info["type"] = tostring(_contact.type)
        info["type_desciption"] = tostring(_contact.type_description)
        info["speed"] = tostring(_contact.speed)
        info["altitude"] = tostring(_contact.altitude)
        info["_contact"] = tostring(get_last_detection_age(_contact))
        info["classificationlevel"] = tostring(_contact.classificationlevel)
        return info
    end
    local _contacts_list = ScenEdit_GetContacts(_side)
    if is_empty(_contacts_list) then
        print("No Contacts")
        ScenEdit_MsgBox("No Contacts",0)
        return
    end
    local result = {}
    for k,_contact in pairs(_contacts_list) do
        -----Enter Tasks here-----
        result = {[_contact.name]=display_contact_info(_contact)}
    end
    return result
end
print("-----START-----")
print(TOSTRING(get_contacts_info(ScenEdit_PlayerSide())))
print("-----END-----")
print("")
print("")