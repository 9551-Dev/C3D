local per_matrix = require("core.3D.matrice.perspective")

return {make=function(ENV,BUS,terminal_getter)
    local terminal = terminal_getter()
    local last_x,last_y = terminal.getSize()
    return coroutine.create(function()
        while true do
            terminal = terminal_getter()
            if BUS.graphics.auto_resize then
                local cx,cy = terminal.getSize()
                if cx ~= last_x or cy ~= last_y then
                    BUS.graphics.display_source.reposition(1,1,cx,cy)
                    BUS.graphics.w = cx*2
                    BUS.graphics.h = cy*3
                    last_x,last_y = cx,cy
                    BUS.perspective.matrix = per_matrix(cx*2,cy*3,
                        BUS.perspective.near,
                        BUS.perspective.far,
                        BUS.perspective.FOV
                    )
                end
            end
            coroutine.yield()
        end
    end)
end}