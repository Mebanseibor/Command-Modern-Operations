local msg=[[
<h2 align="center">Tools</h2>
<form>
    <p>
        General
        <br>
        <select name="General">
            <option value="Select">Select</option>
            <option value="Emission Analysis">Emission Analysis</option>
            <option value="Distance(with slant)">Distance(with slant)</option>
        </select>
        <br>
        <br>
        Selected Unit
        <br>
        <select name="Selected Unit">
            <option value="Select">Select</option>
            <option value="Emission Analysis">Emission Analysis</option>
        </select>
    </p>
</form>
]]


-----**UTILITY FUNCTIONS**-----
local function is_empty(data)
    if data==nil or #data==0 then return true end
    return false
end

local function table_has_element(_table,_element)
    -- Error Handling
    if type(_table)~="table" then
        print("Error: Input is not a table")
        return false
    end
    if is_empty(_table) then
        return false
    end
    for k,v in pairs (_table) do
        if v==_element then
            return true
        end
    end
    return false
end

local function is_selected(selection)
    if selection=="Select" then return false end
    return true
end

local function trim(data)
    data = string.gsub(data, "^'", "") -- Removes starting quote
    data = string.gsub(data, "'$", "") -- Removes ending quote
    return data
end
--------------------------------





-----**HTML CALLER**-----
local button = UI_CallAdvancedHTMLDialog("Tools", msg, {"Submit","Cancel"})
for k,v in pairs(button) do
    print(k .. ' = ' .. v)
end
--Error Handling
if is_empty(button.pressed) or button.pressed=="Cancel" then
    print("Aborted")
    return
end
-------------------------





-----**FUNCTIONS**-----
local function print_contacts_emisions(i_contact_list)
    --Local Functions--
    local function is_table_empty(lf_table)
        if lf_table==nil or #lf_table == 0 then return true
        else return false end
    end
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
---------------------------




-----**EVALUATION**-----
-----<<Selector: General>>-----
if is_selected(button[General]) then
    local selection=trim(button.General)

    if selection=="Emission Analysis" then
        print_contacts_emisions(ScenEdit_GetContacts(ScenEdit_PlayerSide()))
    end
end