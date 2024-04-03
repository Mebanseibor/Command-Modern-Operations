-----Checks if a table is empty or not-----
local function is_empty(lf_table)
    if lf_table==nil or #lf_table==0 then return true
    else return false end
end
-------------------------------------------



local v_side = "Blue" --Enter side
local v_contact_list = ScenEdit_GetContacts(v_side)   -- Parameters: Side



-----Get Last Contact-----
local function get_last_contact(i_contact_list)
    if(is_empty(i_contact_list)) then
        print("No contacts in list")
        return -1
    end
    local _last_contact = i_contact_list[#i_contact_list]
    return _last_contact
end
local v_last_contact = get_last_contact(v_contact_list)  -- Parameters: Contact table
-------------------------



-----Get Last detection age-----
local function get_last_detection_age(i_contact)
    return i_contact.lastDetections[1].age
end
local v_last_detection_age=get_last_detection_age(v_contact_list[1]) -- Parameters: contact