-----**EVENTS**-----
local function ScenEdit_AddEvent_FollowContact(_name)
    local _mode="add"
    local _description="Follow Contact ".._name
    local _IsRepeatable=true
    ScenEdit_SetEvent(_name,{mode=_mode,IsRepeatable=_IsRepeatable})
end
--local event_name="Approach Event ".._unit.name
--ScenEdit_AddEvent_FollowContact(event_name)
---------------------





-----**TRIGGERS**-----
local function ScenEdit_AddEventTrigger_Timer(event_name, timer)
    local t = ScenEdit_SetEventTrigger(event_name,{mode = 'add', description = string.format("Timer of %s seconds",timer)})
    print(t)
end
---------------------