local tbl = require("common.table_util")

return {read=function(path_tex,BUS,options)
    local file = fs.open(path_tex,"r")
    local file_data = file.readAll()
    file.close()

    local map = tbl.createNDarray(1)

    local as_transparency = tbl.createNDarray(1)

    local image_data = textutils.unserialize(file_data)
    for k1,v1 in pairs(image_data) do
        for k2,v2 in pairs(v1) do
            local s = v2:sub(2,2)

            as_transparency[k2][k1] = s == "f"

            map[k2][k1] = 2^tonumber(s,16)
        end
    end
    local res = {
        w=#map[#map],
        h=#map,
        pixels=map,
        as_transparency=as_transparency,
    }
    return res
end}