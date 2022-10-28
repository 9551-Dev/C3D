local tbls = require("common.table_util")

local cUtil = {}

local palette = {}
local color_cache = tbls.createNDarray(2)

local SQRT,MAX,MIN = math.sqrt,math.max,math.min

function cUtil.update_palette(terminal)
    color_cache = tbls.createNDarray(2)
    for i=0,15 do
        local r,g,b = terminal.getPaletteColor(2^i)
        palette[2^i] = {r,g,b}
    end
end

function cUtil.set_palette(pal)
    color_cache = tbls.createNDarray(2)
    for index,v in ipairs(pal) do
        local i = 2^(index-1)
        palette[i] = {v[1],v[2],v[3]}
    end
end

function cUtil.find_closest_color(r,g,b)
    local n,result = 0,color_cache[r][g][b] or {}
    if not next(result) then
        for k,v in pairs(palette) do
            n=n+1
            result[n] = {
                dist=SQRT(
                    (v[1]-r)^2 +
                    (v[2]-g)^2 +
                    (v[3]-b)^2
                ),  color=k,
                r=v[1],g=v[2],b=v[3]
            }
        end
        table.sort(result,function(a,b) return a.dist < b.dist end)
        color_cache[r][g][b] = result
    end
    local r = result[1]
    return r.color,r.r,r.g,r.b
end

function cUtil.get_palette()
    return palette
end

return cUtil