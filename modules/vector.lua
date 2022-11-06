return function(BUS)

    return function()
        local vector = plugin.new("c3d:vector")

        function vector.register_modules()
            local module_registry = c3d.registry.get_module_registry()
            local vector_module   = module_registry:new_entry("vector")

            vector_module:set_entry(c3d.registry.entry("new"),function(x,y,z)
                return BUS.object.vector.new(x,y,z)
            end)
        end

        vector:register()
    end
end