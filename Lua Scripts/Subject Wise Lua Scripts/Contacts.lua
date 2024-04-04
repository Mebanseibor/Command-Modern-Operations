-----Functions-----
--[[
    get_last_contact(contact_list)  --Parameters: Contact table
    get_last_detection_age(contact) --Parameters: Contact
]]--





-----**Utility Functions**-----
-----Checks if a data/table is empty or not-----
local function is_empty(data)
    if data==nil or #data==0 then return true end
    return false
end
-------------------------------------------





-----Get Last Contact-----
local function get_last_contact(i_contact_list)
    if(is_empty(i_contact_list)) then
        print("No contacts in list")
        return -1
    end
    local _last_contact = i_contact_list[#i_contact_list]
    return _last_contact
end
-------------------------



-----Get Last detection age-----
local function get_last_detection_age(i_contact)
    return i_contact.lastDetections[1].age
end
--------------------------------