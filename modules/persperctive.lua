local persperctive = {}

local persperctive_matrix = require("core.3D.matrice.persperctive")

return function(BUS)

    local function update_persperctive()
        local BPER = BUS.persperctive
        local BGPS = BUS.graphics

        BPER.matrix = persperctive_matrix(BGPS.w,BGPS.h,
            BPER.near,
            BPER.far,
            BPER.FOV
        )
    end

    function persperctive.set_near_plane(near)
        BUS.persperctive.near = near
        update_persperctive()
    end
    function persperctive.set_far_plane(far)
        BUS.persperctive.far = far
        update_persperctive()
    end

    function persperctive.set_fov(fov)
        BUS.persperctive.FOV = fov
        update_persperctive()
    end
    
    return persperctive
end