--CMOT should not be local
CMOT = "CMOT/"
-----**Required Scripts**-----
ScenEdit_RunScript(CMOT.."base/General Utility Functions.lua")
ScenEdit_RunScript(CMOT.."base/HTML Functions.lua")
------------------------------





--[[
    -The following strings should contain the script's name that the option should run
    -For <select> input,
        -Substituite the <option> tag in the HTML string with a function "HTML_option(msg,script_name)"
    -Default scripts location:
        *Command modern operation main folder*
            Lua
                *CMOT*
]]--
-----<<Buttons>>-----
-----General-----
local script_contact_emissions="/CMOT/Scripts/CMOT/Contact Emissions"
local script_monitor_contacts_emissions="/CMOT/Scripts/CMOT/Monitor Contacts Emissions"
-----Selected Unit-----
local script_follow_contact = "/CMOT/Scripts/CMOT/Follow Contact"





-----**MAIN HTML**-----
local msg=HTML_Init()
msg[1]=[[
<h2 align="center">Tools</h2>
<form>
    <p>
        General
        <br>
        <select name="General">]]
            HTML_option(msg,"Select")
            HTML_option(msg,script_contact_emissions)
            HTML_option(msg,script_monitor_contacts_emissions)
msg[1]=msg[1]..
        [[</select>
        <br>
        <br>
        Selected Unit
        <br>
        <select name="Selected Unit">]]
            HTML_option(msg,"Select")
            HTML_option(msg,script_follow_contact,"Follow Contact")
msg[1]=msg[1]..
        [[</select>
    </p>
</form>
]]
--------------------------------





-----**HTML CALLER**-----
local button = UI_CallAdvancedHTMLDialog("Tools", msg[1], {"Submit","Cancel"})
for k,v in pairs(button) do
    print(k .. ' = ' .. v)
end
--Error Handling
if is_empty(button.pressed) or button.pressed=="Cancel" then
    print("Aborted")
    return
end
-------------------------





-----**EVALUATION**-----
-----<<Selector: General>>-----
if is_selected(button["General"]) then
    local selection=trim(button["General"])

    if selection==script_contact_emissions then
        run_script(script_contact_emissions)
    elseif selection==script_monitor_contacts_missions then
        run_script(script_monitor_contacts_missions)
    end
end
if is_selected(button["Selected Unit"]) then
    local selection=trim(button["Selected Unit"])

    if selection==script_follow_contact then
        run_script(script_follow_contact)
    end
end