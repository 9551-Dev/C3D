local perspective = {}

local perspective_matrix = require("core.3D.matrice.perspective")

return function(BUS)

    local function update_perspective()
        local BPER = BUS.perspective
        local BGPS = BUS.graphics

        BPER.matrix = perspective_matrix(BGPS.w/BGPS.pixel_size,BGPS.h/BGPS.pixel_size,
            BPER.near,
            BPER.far,
            BPER.FOV
        )
    end

    function perspective.set_near_plane(near)
        BUS.perspective.near = near
        update_perspective()
    end
    function perspective.set_far_plane(far)
        BUS.perspective.far = far
        update_perspective()
    end

    function perspective.set_fov(fov)
        BUS.perspective.FOV = fov
        update_perspective()
    end
    
    return perspective,update_perspective
end