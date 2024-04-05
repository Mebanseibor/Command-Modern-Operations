--[[
    Functions:
        HTML_Init()
        HTML_h(msg,heading,heading size[,close?])
        HTML_p(msg,[text,close?])
]]--

-----**GENERAL UTILITY FUNCTIONS**-----
--<<Booleans>>--
local function is_boolean(data)return type(data)=="boolean" end
local function is_not_boolean(data)return type(data)~="boolean" end
local function is_number(data)return type(data)=="number" end
local function is_not_number(data)return type(data)~="number" end
local function is_table(data)return type(data)=="table" end
local function is_not_table(data)return type(data)~="table" end
local function is_string(data)return type(data)=="string" end
local function is_not_string(data)return type(data)~="string" end
local function is_nil(data)return type(data)=="nil" end

local function is_empty(data)
    if data==nil or (is_not_boolean(data) and is_not_number(data) and #data == 0) then return true
    else return false end
end

--<<HTML Base Functions>>--
local function is_HTML_valid(_msg)
    if is_nil(_msg) then
        error("Insufficient Parameter: is_HTML_valid(_msg)",2)
    end
    if is_not_table(_msg) then
        error("Invalid Parameter #1: Should be a table",3)
    elseif type(_msg[1])~="string" then
        error("Invalid Parameter #1: Should be a table of string",3)
    end
end

local function HTML_Init()
    return {""}
end

local function HTML_h(_msg,_header,_size,_end)
    -- Error Handling
    is_HTML_valid(_msg)
    if is_not_string(_header) then
        error("Invalid Parameter #2: Heading must be of type string",2)
    elseif _size<1 or 6<_size then
        error("Invalid Parameter #3: Expected value 1 till 6",2)
    end

    --Build header
    _msg[1]=_msg[1].."<h".._size..">".._header
    
    --Check for ending order
    if is_empty(_end) then return end
    if is_boolean(_end)then
        if _end==true then
            --Build ending tag
            _msg[1]=_msg[1].."</h".._size..">" return
        else return end
    else
        error("Invalid Parameter #4: Expected a Boolean",2)
    end
end
    

local function HTML_p(_msg,text,_end)
    is_HTML_valid(_msg)
    
    --Check for text
    if is_empty(text) then
        _msg[1]=_msg[1].."<p>"
        return
    elseif is_not_string(text) then
        error("Invalid Parameter #2: Expected a string",2)
    end
    
    --Build Paragraph
    _msg[1]=_msg[1].."<p>"..text

    --Check for ending order
    if is_empty(_end) then return _msg end
    if is_boolean(_end) then
        if _end==true then
            _msg[1]=_msg[1].."</p>" return end
    else
        error("Invalid Parameter: Expected a Boolean value",2)
    end 
end

local function HTML_br(_msg)
    is_HTML_valid(_msg)
    _msg[1]=_msg[1].."<br>"
    return
end



-----**MAIN BODY**-----
local function Test()
    local msg=HTML_Init()
    HTML_h(msg,"Heading L2",2,true)
    HTML_p(msg,"Paragraph #1",true)
    HTML_h(msg,"Heading L4",4,true)
    HTML_p(msg,"Side: ")
    msg[1]=msg[1]..ScenEdit_PlayerSide()
    HTML_br(msg)
    HTML_p(msg)
    print(msg[1])

    UI_CallAdvancedHTMLDialog("Test",msg,{"OK"})
end
Test()
print("Done")
print("")