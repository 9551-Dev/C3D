local tbl = require("common.table_util")

return {read=function(BUS,path_tex)
    local fl = fs.open(path_tex,"r")
    local map = tbl.createNDarray(1)
    local cm = textutils.unserialize(fl.readAll())
    for k1,v1 in pairs(cm) do
        for k2,v2 in pairs(v1) do
            map[k2][k1] = 2^tonumber(string.sub(v2,2,2),16)
        end
    end
    local res = {
        w=#map+1,
        h=#map[#map]-1,
        pixels=map
    }
    return res
end}
