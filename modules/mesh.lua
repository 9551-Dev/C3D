return function(BUS)

    return function()
        local mesh = plugin.new("c3d:mesh")

        function mesh.register_modules()
            local module_registry = c3d.registry.get_module_registry()
            local mesh_module     = module_registry:new_entry("mesh")

            mesh_module:set_entry(c3d.registry.entry("new"),function()
                return BUS.object.raw_mesh.new()
            end)
        end

        mesh:register()
    end
end