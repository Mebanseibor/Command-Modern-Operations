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
local function ScenEdit_AddEventTrigger_Timer(_event, timer)
    ScenEdit_SetTrigger({mode='add',type="RegularTime", interval=4,description=string.format("Timer of %s seconds",timer)})
end
---------------------