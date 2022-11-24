local tbl = require("common.table_util")

return {read=function(path_tex,BUS,options)
    local file = fs.open(path_tex,"r")
    local file_data = file.readAll()
    file.close()

    local map = tbl.createNDarray(1)
    local as_transparency = tbl.createNDarray(1)
    local lines = {}

    local width,height = 0,0
    for str in file_data:gmatch("([^\n]+)") do
        height = height + 1
        width = math.max(width,#str)
        lines[height] = str
    end

    for i=1,#lines do
        local line_string = lines[i]
        for s=1,width do
            local char = line_string:sub(s,s)
            if char == "f" or char == "" or char == " " then
                as_transparency[i][s] = true
                map[i][s] = colors.black
            else
                as_transparency[i][s] = false
                map[i][s] = 2^tonumber(char,16)
            end
        end
    end

    map.w,map.h = width,height

    local res = {
        w=width,
        h=height,
        pixels={map},
        as_transparency={as_transparency},
    }
    return res
end}