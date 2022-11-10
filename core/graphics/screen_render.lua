local tbl = require("common.table_util")
local chr = require("common.draw_util")
local tb = chr.to_blit
local make_draw_char = chr.build_drawing_char

local t_cat = table.concat
local type  = _G.type

local memory_manager = require("core.mem_manager")

return {build=function(BUS,scene)

    BUS.log("  - Inicialized screen renderer",BUS.log.info)

    local mem_handle = memory_manager.get(BUS)

    local busg = BUS.graphics
    return {make_frame=function()
        local timer = BUS.c3d.timer
        local trendst = os.epoch("utc")
        scene.render()
        local trendet = os.epoch("utc")
        busg.stats.render_total = trendet-trendst

        local bgw = busg.w
        local canv = busg.buffer
        local sy = 0

        local set_cursor = busg.display_source.setCursorPos
        local blit_line  = busg.display_source.blit

        local sust = os.epoch("utc")
        if type(BUS.c3d.screen_render) == "function" then
            BUS.c3d.screen_render(busg.display_source,busg.w,busg.h,canv)
        else
            local char_line,fg_line,bg_line = mem_handle.get_table(),mem_handle.get_table(),mem_handle.get_table()
            for y=1,busg.h,3 do
                sy = sy + 1
                local layer_1 = canv[y]
                local layer_2 = canv[y+1]
                local layer_3 = canv[y+2]
                local n = 0
                for x=1,bgw,2 do
                    local xp1 = x+1
                    local b11,b21,b12,b22,b13,b23 =
                        layer_1[x],layer_1[xp1],
                        layer_2[x],layer_2[xp1],
                        layer_3[x],layer_3[xp1]

                    local char,fg,bg = " ",1,b11
                    if not (b21 == b11
                        and b12 == b11
                        and b22 == b11
                        and b13 == b11
                        and b23 == b11) then
                        char,fg,bg = make_draw_char(b11,b21,b12,b22,b13,b23)
                    end
                    n = n + 1
                    char_line[n] = char
                    fg_line  [n] = tb[fg]
                    bg_line  [n] = tb[bg]
                end

                set_cursor(1,sy)
                blit_line(
                    t_cat(char_line,""),
                    t_cat(fg_line,""),
                    t_cat(bg_line,"")
                )
            end
        end
        local suet = os.epoch("utc")
        busg.stats.screen_update = suet-sust
        busg.stats.fps = timer.getFPS()
        busg.stats.frame_time = timer.get_delta()
    end}
end}
