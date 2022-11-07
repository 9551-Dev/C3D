local per_matrix = require("core.3D.matrice.perspective")

return {make=function(ENV,BUS,terminal_getter)

    BUS.log("   - Created screen resize handler thread",BUS.log.success)

    local terminal = terminal_getter()
    local last_x,last_y = terminal.getSize()
    if terminal.getGraphicsMode then last_x,last_y = terminal.getSize(terminal.getGraphicsMode()) end
    return coroutine.create(function()
        while true do
            terminal = terminal_getter()
            
            local cx,cy = terminal.getSize()
            if terminal.getGraphicsMode then cx,cy = terminal.getSize(terminal.getGraphicsMode()) end
            if cx ~= last_x or cy ~= last_y then
                last_x,last_y = cx,cy
                if BUS.graphics.auto_resize then
                    BUS.graphics.display_source.reposition(1,1,cx,cy)
                    BUS.graphics.w = cx*2
                    BUS.graphics.h = cy*3
                    BUS.perspective.matrix = per_matrix(cx*2,cy*3,
                        BUS.perspective.near,
                        BUS.perspective.far,
                        BUS.perspective.FOV
                    )
                end
                if type(ENV.c3d.resize) == "function" then ENV.c3d.resize(cx,cy) end
            end
            
            coroutine.yield()
        end
    end)
end}