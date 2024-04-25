--<<ADVANCE HTML DIALOG related functions>>--
function is_selected(selection)
    if selection=="Select" then return false end
    return true
end

function trim(data)
    data = string.gsub(data, "^'", "") -- Removes starting quote
    data = string.gsub(data, "'$", "") -- Removes ending quote
    return data
end
---------------------------------------------

--<<HTML Tag Functions>>--
function is_HTML_valid(_msg)
    if is_nil(_msg) then
        error("Insufficient Parameter: is_HTML_valid(_msg)",2)
    end
    if is_not_table(_msg) then
        error("Invalid Parameter #1: Should be a table",3)
    elseif type(_msg[1])~="string" then
        error("Invalid Parameter #1: Should be a table of string",3)
    end
end

function is_table_valid(headers, data_sets)
    --for titles--
    if is_not_table(headers) then
        error("Invalid Parameter #2: Expected Table",3)
    elseif is_empty(headers) then
        error("Invalid Parameter #2: Expected non-empty Table",3)
    end
    
    --for data_sets--
    if is_nil(data_sets) then
        return
    elseif is_not_table(data_sets) then
        error("Invalid Parameter #3: Expected a table",3)
    elseif is_empty(data_sets) then
        error("Invalid Parameter #3: Expected non-empty Table",3)
    end
    for k, data_set in pairs(data_sets) do
        if is_not_table(data_set) then
            error(string.format("Invalid Parameter #3: Dataset at position %s is not a table",k),3)
        elseif is_empty(data_set) then
            error(string.format("Invalid Parameter #3: Dataset at position %s is empty",k),3)
        elseif #data_set~=#headers then
            error(string.format("Invalid Parameter #3: Dataset at position %s does not match with number of columns",k),3)
        end
    end
end

function HTML_Init()
    return {""}
end

function HTML_h(_msg,_header,_size,_end)
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
    

function HTML_p(_msg,text,_end)
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

function HTML_br(_msg)
    is_HTML_valid(_msg)
    _msg[1]=_msg[1].."<br>"
    return
end

function HTML_li(_msg,items)
    is_HTML_valid(_msg)
    if is_not_table(items) then
        error("Invalid Parameter #2: Expected a table",2)
    end
    if is_empty(items) then
        error("Invalid Value #2: Table must not be empty",2)
    end
    for k,item in pairs(items) do
        _msg[1]=_msg[1].."<li>"..tostring(item).."</li>"
    end
end

function HTML_table(_msg,headers,data_sets)
    --{{row1},{row2}}
    is_HTML_valid(_msg)
    is_table_valid(headers,data_sets)
    
    --if data is not collected
    if is_nil(data_sets) then return false end
    --Builder
    _msg[1]=_msg[1].."<table border =\"1\"><tbody>"
    --Build headers
    _msg[1]=_msg[1].."<tr>"
    for k,header in pairs(headers) do
        _msg[1]=_msg[1].."<th>"..tostring(header).."</th>"
    end
    _msg[1]=_msg[1].."</tr>"

    --Build content
    for k,data_set in pairs(data_sets) do
        _msg[1]=_msg[1].."<tr>"
        for l, data in pairs(data_set) do
            _msg[1]=_msg[1].."<td>"..tostring(data).."</td>"
        end
        _msg[1]=_msg[1].."</tr>"
    end
    _msg[1]=_msg[1].."</tbody></table>"
    return true
end

function HTML_option(_msg,script_name,text)
    is_HTML_valid(_msg)
    if is_empty(script_name) and is_not_string(script_name) then
        error("Invalid Parameter #2: Expected non-empty String",2)
    end
    if is_nil(text) or is_empty(text) then
        text=script_name
    end
    _msg[1]=_msg[1].."<option value=\""..script_name.."\">"..text.."</option>"
end