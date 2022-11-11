return function(BUS)
    return function()
        local mouse = plugin.new("c3d:module->mouse")

        function mouse.register_modules()
            local module_registry = c3d.registry.get_module_registry()
            local mouse_module    = module_registry:new_entry("mouse")

            mouse_module:set_entry(c3d.registry.entry("get_position"),function()
                return BUS.mouse.last_x, BUS.mouse.last_y
            end)
            mouse_module:set_entry(c3d.registry.entry("get_x"),function() return BUS.mouse.last_x end)
            mouse_module:set_entry(c3d.registry.entry("get_y"),function() return BUS.mouse.last_y end)
            mouse_module:set_entry(c3d.registry.entry("is_down"),function(...)
                local btn_list = {...}
                for k,key in pairs(btn_list) do
                    local held = BUS.mouse.held[key]
                    if not held then return false end
                end
                return true
            end)
            mouse_module:set_entry(c3d.registry.entry("set_position"),function(x,y)
                BUS.mouse.last_x = x
                BUS.mouse.last_y = y
            end)
            mouse_module:set_entry(c3d.registry.entry("set_x"),function(x) BUS.mouse.last_x = x end)
            mouse_module:set_entry(c3d.registry.entry("set_y"),function(y) BUS.mouse.last_y = y end)
        end

        mouse:register()
    end
end
