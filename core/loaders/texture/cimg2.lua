local tbl = require("common.table_util")

return {read=function(BUS,path_tex)
    local fl = fs.open(path_tex,"r")
    local map = tbl.createNDarray(1)
    local cm = textutils.unserialize(fl.readAll())
    for k1,v1 in pairs(cm) do
        for k2,v2 in pairs(v1) do
            local tbl = {}
            tbl[1] = string.sub(v2,1,1) -- c
            tbl[2] = string.sub(v2,2,2) -- b
            tbl[3] = string.sub(v2,3,3) -- f
            map[k1][k2] = tbl
        end
    end
    local retmap = tbl.createNDarray(1)
    for k1,v1 in pairs(map) do
        for k2,v2 in pairs(v1) do
            retmap[k2][k1] = 2^tonumber(v2[2],16)
        end
    end
    local res = {
        w=#map,
        h=#map[#map],
        pixels=retmap
    }
    return res
end}
