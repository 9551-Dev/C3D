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

    return function()
        local perspective = plugin.new("c3d:module->perspective")

        function perspective.register_modules()
            local module_registry    = c3d.registry.get_module_registry()
            local perspective_module = module_registry:new_entry("perspective")

            perspective_module:set_entry(c3d.registry.entry("set_near_plane"),function(near)
                BUS.perspective.near = near
                update_perspective()
            end)
            perspective_module:set_entry(c3d.registry.entry("set_far_plane"),function(far)
                BUS.perspective.far = far
                update_perspective()
            end)

            perspective_module:set_entry(c3d.registry.entry("set_fov"),function(fov)
                BUS.perspective.FOV = fov
                update_perspective()
            end)
        end

        perspective:register()
    end,update_perspective
end
