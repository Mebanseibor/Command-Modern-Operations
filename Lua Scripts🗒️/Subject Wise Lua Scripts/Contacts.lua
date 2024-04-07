-----Functions-----
--[[
    get_last_contact(contact_list)  --Parameters: Contact table
    get_last_detection_age(contact) --Parameters: Contact
]]--





-----Get Last Contact-----
function get_last_contact(i_contact_list)
    if(is_empty(i_contact_list)) then
        print("No contacts in list")
        return -1
    end
    local _last_contact = i_contact_list[#i_contact_list]
    return _last_contact
end
-------------------------



-----Get Last detection age-----
function get_last_detection_age(i_contact)
    return i_contact.lastDetections[1].age
end
--------------------------------




-----Convert Posture Character <===> Posture String-----
function convert_contact_posture(_posture)
    if is_empty(_posture) or is_not_string(_posture) then
        error("Invalid Parameter: Expected a string",2)
    end
    if _posture=="H" then return "Hostile" end
    if _posture=="U" then return "Unfriendly" end
    if _posture=="X" then return "Unknown" end
    if _posture=="N" then return "Nuetral" end
    if _posture=="F" then return "Friendly" end
    if _posture=="Hostile" then return "H" end
    if _posture=="Unfriendly" then return "U" end
    if _posture=="Unknown" then return "X" end
    if _posture=="Nuetral" then return "N" end
    if _posture=="Friendly" then return "F" end
end
--------------------------------------------------------