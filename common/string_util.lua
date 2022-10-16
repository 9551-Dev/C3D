local strings = {}

local expect = require("cc.expect").expect

function strings.wrap(str,lenght,nnl)
    expect(1,str,"string")
    expect(2,lenght,"number")
    local words,out,outstr = {},{},""
    for c in str:gmatch("[%w%p%a%d]+%s?") do table.insert(words,c) end
    if lenght == 0 then return "" end
    while outstr < str and not (#words == 0) do
        local line = ""
        while words ~= 0 do
            local word = words[1]
            if not word then break end
            if #word > lenght then
                local espaces = word:match("% +$") or ""
                if not ((#word-#espaces) <= lenght) then
                    local cur,rest = word:sub(1,lenght),word:sub(lenght+1)
                    if #(line..cur) > lenght then words[1] = strings.wrap(cur..rest,lenght,true) break end
                    line,words[1],word = line..cur,rest,rest
                else word = word:sub(1,#word-(#word - lenght)) end
            end
            if #(line .. word) <= lenght then
                line = line .. word
                table.remove(words,1)
            else break end
        end
        table.insert(out,line)
    end
    return table.concat(out,nnl and "" or "\n")
end

function strings.cut_parts(str,part_size)
    expect(1,str,"string")
    expect(2,part_size,"number")
    local parts = {}
    for i = 1, #str, part_size do
        parts[#parts+1] = str:sub(i, i+part_size-1)
    end
    return parts
end

function strings.ensure_size(str,width)
    expect(1,str,"string")
    expect(2,width,"number")
    local f_line = str:sub(1, width)
    if #f_line < width then
        f_line = f_line .. (" "):rep(width-#f_line)
    end
    return f_line
end

function strings.newline(tbl)
    expect(1,tbl,"table")
    return table.concat(tbl,"\n")
end

function strings.wrap_lines(str,lenght)
    local result_str = ""
    for c in str:gmatch("([^\n]+)") do
        result_str = result_str .. strings.wrap(c,lenght) .. "\n"
    end
    return result_str
end

function strings.ensure_line_size(str,width)
    local result_str = ""
    for c in str:gmatch("([^\n]+)") do
        result_str = result_str .. strings.ensure_size(c,width) .. "\n"
    end
    return result_str
end

return strings