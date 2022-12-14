local ppm = require("lib.luappm")

local tbl = require("common.table_util")

local c_util = require("common.color_util")

local quantize = require("core.graphics.quantize")
local dither   = require("core.graphics.dither")

return {read=function(path_tex,BUS,options,option_results,final)
    c_util.update_palette(BUS.graphics.display_source)

    local map_color = ppm(path_tex)

    local res = {
        w=map_color.w,
        h=map_color.h,
        pixels={tbl.createNDarray(1)},
        as_transparency={tbl.createNDarray(1)},
    }

    local pxels = res.pixels[1]
    local trans = res.as_transparency[1]

    if options.quantize_amount then
        local mc = map_color
        local res = quantize.quant(mc,mc.w,mc.h,options.quantize_amount)
        option_results.quantized = BUS.object.palette.new(res,final)
        c_util.set_palette(res)
    end

    for y=1,map_color.h do
        for x=1,map_color.w do
            local px = map_color[y][x]
            local fr,fg,fb = px[1],px[2],px[3]

            trans[y][x] = (fr+fg+fb)/3 < 0.5

            local c,r,g,b = c_util.find_closest_color(
                fr,fg,fb
            )

            if options.dither then dither.dith(map_color,fr,fg,fb,r,g,b,x,y) end
            pxels[y][x] = c
        end
    end

    pxels.w = map_color.w
    pxels.h = map_color.h

    return res
end}
