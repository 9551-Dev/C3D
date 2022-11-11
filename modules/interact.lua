local floor = math.floor

return function(BUS)
    local bus_interactions = BUS.interactions

    return function()
        local interact = plugin.new("c3d:module->interact")

        function interact.register_modules()
            local module_registry = c3d.registry.get_module_registry()
            local interact_module = module_registry:new_entry("interact")

            interact_module:set_entry(c3d.registry.entry("enable"),function(state)
                BUS.interactions.running = state
            end)

            interact_module:set_entry(c3d.registry.entry("get_triangle"),function(x,y)
                local map = bus_interactions.map
                return map[floor(y)*3][floor(x)*2]
            end)
            interact_module:set_entry(c3d.registry.entry("get_object"),function(x,y)
                local map = bus_interactions.map
                local triangle = map[floor(y)*3][floor(x)*2]
                if triangle then return triangle.object end
                return nil
            end)

            interact_module:set_entry(c3d.registry.entry("get_triangle_pixel"),function(x,y)
                local map = bus_interactions.map
                return map[floor(y)][floor(x)]
            end)
            interact_module:set_entry(c3d.registry.entry("get_object_pixel"),function(x,y)
                local map = bus_interactions.map
                local triangle = map[floor(y)][floor(x)]
                if triangle then return triangle.object end
                return nil
            end)
        end

        interact:register()
    end
end