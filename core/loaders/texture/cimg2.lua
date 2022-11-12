local tbl = require("common.table_util")

return {read=function(BUS,path_tex,options)
    local fl = fs.open(path_tex,"r")
    local map = tbl.createNDarray(1)

    local as_transparency = tbl.createNDarray(1)

    local cm = textutils.unserialize(fl.readAll())
    for k1,v1 in pairs(cm) do
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
        transparency=options.transparency
    }
    return res
end}
