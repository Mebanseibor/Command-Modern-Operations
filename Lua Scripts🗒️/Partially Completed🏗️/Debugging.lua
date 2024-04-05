--[[
    Irrelevant, code cause the in-built function "error(string,error_level)" does the same thing
]]--

--<<Debugging>>--
local function get_caller_line(level)
    local info = debug.getinfo(level+1, "Sl")
    return(info.currentline)
end

local function Err(err_msg)
    print(string.format("ERROR: Line %d: %s",get_caller_line(3),err_msg))
end
-----------------------------------