return function(BUS)
    return function()
        local scene = plugin.new("c3d:scene")

        function scene.register_modules()
            local module_registry = c3d.registry.get_module_registry()
            local scene_module    = module_registry:new_entry("scene")

            scene_module:set_entry(c3d.registry.entry("add_geometry"),function(geom)
                return BUS.object.scene_obj.new(geom)
            end)
        end

        scene:register()
    end
end