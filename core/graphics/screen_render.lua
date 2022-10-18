local tbl = require("common.table_util")
local chr = require("common.draw_util")
local tb = chr.to_blit
local make_draw_char = chr.build_drawing_char

local t_cat = table.concat

return {build=function(BUS,scene)
    local busg = BUS.graphics
    return {make_frame=function()
        scene.render()
        local bgw = BUS.graphics.w
        local canv = BUS.graphics.buffer
        local sy = 0

        local set_cursor = BUS.graphics.display_source.setCursorPos
        local blit_line  = BUS.graphics.display_source.blit

        for y=1,busg.h,3 do
            sy = sy + 1
            local layer_1 = canv[y]
            local layer_2 = canv[y+1]
            local layer_3 = canv[y+2]
            local char_line,fg_line,bg_line = {},{},{}
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
        term.setCursorPos(1,1)
        term.write("FPS: "..BUS.c3d.timer.getFPS())
    end}
end}