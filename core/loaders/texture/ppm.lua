local ppm = require("lib.luappm")

local tbl = require("common.table_util")

local c_util = require("common.color_util")

return {read=function(BUS,path_tex)
    c_util.update_palette(BUS.graphics.display_source)

    local map_color = ppm(path_tex)

    local res = {
        w=map_color.w,
        h=map_color.h,
        pixels=tbl.createNDarray(1)
    }

    local pxels = res.pixels

    for y=1,map_color.h do
        for x=1,map_color.w do
            local px = map_color[y][x]
            pxels[y][x] = c_util.find_closest_color(
                px[1],
                px[2],
                px[3]
            )
        end
    end

    return res
end}
