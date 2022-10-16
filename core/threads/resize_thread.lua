local per_matrix = require("core.3D.matrice.persperctive")

return {make=function(ENV,BUS,terminal)
    local last_x,last_y = terminal.getSize()
    return coroutine.create(function()
        while true do
            local cx,cy = terminal.getSize()
            if cx ~= last_x or cy ~= last_y then
                BUS.graphics.display_source.reposition(1,1,cx,cy)
                BUS.graphics.w = cx*2
                BUS.graphics.h = cy*3
                last_x,last_y = cx,cy
                BUS.persperctive.matrix = per_matrix(cx*2,cy*3,
                    BUS.persperctive.near,
                    BUS.persperctive.far,
                    BUS.persperctive.FOV
                )
            end
            sleep(0.1)
        end
    end)
end}