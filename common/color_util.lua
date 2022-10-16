local tbls = require("common.table_util")

local cUtil = {blend={
    alpha={},
    add={},
    subtract={},
    replace={},
    multiply={},
    lighten={},
    darken={},
    screen={}
}}

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

function cUtil.set_palette(BUS,pal)
    color_cache = tbls.createNDarray(2)
    for index,v in ipairs(pal) do
        local i = 2^(index-1)
        palette[i] = {v[1],v[2],v[3]}
        for k,v in pairs(BUS.sys.reserved_spots) do
            if v[1] == i then
                palette[i] = v[2]
            end
        end
    end
    return {push=function(to)
        for k,v in pairs(palette) do
            to.setPaletteColor(k,v[1],v[2],v[3])
        end
    end}
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

function cUtil.blend.alpha.alphamultiply(dst,src)
    return {
        dst[1] * (1 - src[4]) + src[1] * src[4],
        dst[2] * (1 - src[4]) + src[2] * src[4],
        dst[3] * (1 - src[4]) + src[3] * src[4],
        dst[4] * (1 - src[4]) + src[4]
    }
end

function cUtil.blend.alpha.premultiplied(dst,src)
    return {
        dst[1] * (1 - src[4]) + src[1],
        dst[2] * (1 - src[4]) + src[2],
        dst[3] * (1 - src[4]) + src[3],
        dst[4] * (1 - src[4]) + src[4]

    }
end

function cUtil.blend.add.alphamultiply(dst,src)
    return {
        dst[1] + (src[1] * src[4]),
        dst[2] + (src[2] * src[4]),
        dst[3] + (src[3] * src[4]),
        dst[4]
    }
end

function cUtil.blend.add.premultiplied(dst,src)
    return {
        dst[1] + src[1],
        dst[2] + src[2],
        dst[3] + src[3],
        dst[4]
    }
end

function cUtil.blend.subtract.alphamultiply(dst,src)
    return {
        dst[1] - (src[1] * src[4]),
        dst[2] - (src[2] * src[4]),
        dst[3] - (src[3] * src[4]),
        dst[4]
    }
end

function cUtil.blend.subtract.premultiplied(dst,src)
    return {
        dst[1] - src[1],
        dst[2] - src[2],
        dst[3] - src[3],
        dst[4]
    }
end

function cUtil.blend.replace.alphamultiply(dst,src)
    return {
        src[1] * src[4],
        src[2] * src[4],
        src[3] * src[4]
    }
end

function cUtil.blend.replace.premultiplied(dst,src)
    return {src[1],src[2],src[3]}
end

function cUtil.blend.multiply.alphamultiply(dst,src)
    return {
        src[1]*dst[1],
        src[2]*dst[2],
        src[3]*dst[3],
        src[4]*dst[4]
    }
end

function cUtil.blend.lighten.alphamultiply(dst,src)
    return {
        MAX(src[1],dst[1]),
        MAX(src[2],dst[2]),
        MAX(src[3],dst[3]),
        MAX(src[4],dst[4])
    }
end

function cUtil.blend.darken.alphamultiply(dst,src)
    return {
        MIN(src[1],dst[1]),
        MIN(src[2],dst[2]),
        MIN(src[3],dst[3]),
        MIN(src[4],dst[4])
    }
end

function cUtil.blend.screen.alphamultiply(dst,src)
    return {
        dst[1] * (1 - src[1]) + (src[1] * src[4]),
        dst[2] * (1 - src[2]) + (src[2] * src[4]),
        dst[3] * (1 - src[3]) + (src[3] * src[4]),
        dst[4] * (1 - src[4]) + src[4]
    }
end

function cUtil.blend.screen.premultiplied(dst,src)
    return {
        dst[1] * (1 - src[1]) + src[1],
        dst[2] * (1 - src[2]) + src[2],
        dst[3] * (1 - src[3]) + src[3],
        dst[4] * (1 - src[4]) + src[4]
    }
end

function cUtil.blendf(BUS,existing,additional)
    local blend = BUS.graphics.blending
    return cUtil.blend[blend.mode][blend.alphamode](existing,additional)
end

cUtil.blend.multiply.premultiplied = cUtil.blend.multiply.alphamultiply
cUtil.blend.lighten.premultiplied = cUtil.blend.lighten.alphamultiply
cUtil.blend.darken.premultiplied = cUtil.blend.darken.alphamultiply

return cUtil