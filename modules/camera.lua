return function(BUS)
    local new_camera = BUS.object.camera.new()
        :set_position(0,0,0)
        :set_rotation(0,0,0)

    BUS.camera = new_camera


    return function()
        local camera = plugin.new("c3d:camera")

        function camera.register_modules()
            local module_registry = c3d.registry.get_module_registry()
            local camera_module   = module_registry:new_entry("camera")

            camera_module:set_entry(c3d.registry.entry("set_position"),function(x,y,z)
                BUS.camera:set_position(x,y,z)
            end)
            camera_module:set_entry(c3d.registry.entry("set_rotation"),function(rx,ry,rz,w)
                BUS.camera:set_rotation(rx,ry,rz,w)
            end)

            camera_module:set_entry(c3d.registry.entry("set_transform"),function(transform)
                BUS.camera:set_transform(transform)
            end)

            camera_module:set_entry(c3d.registry.entry("lookat"),function(fromx,fromy,fromz,atx,aty,atz)
                BUS.camera:lookat_transform(fromx,fromy,fromz,atx,aty,atz)
            end)

            camera_module:set_entry(c3d.registry.entry("make"),function(x,y,z,rx,ry,rz,w)
                return BUS.object.camera.new()
                    :set_position(x  or 0,y  or 0,z  or 0)
                    :set_rotation(rx or 0,ry or 0,rz or 0,w or 0)
            end)
            camera_module:set_entry(c3d.registry.entry("set"),function(cam)
                BUS.camera = cam or new_camera
            end)
            camera_module:set_entry(c3d.registry.entry("get"),function()
                return BUS.camera
            end)
        end

        camera:register()
    end
end