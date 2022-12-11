local CEIL = math.ceil

return function(BUS)
    return function()
        local sys = plugin.new("c3d:module->system")

        function sys.register_modules()
            local module_registry = c3d.registry.get_module_registry()
            local system_module   = module_registry:new_entry("sys")

            system_module:set_entry(c3d.registry.entry("get_bus"),function()
                return BUS
            end)

            system_module:set_entry(c3d.registry.entry("fps_limit"),function(limit)
                BUS.sys.frame_time_min = 1/limit
            end)

            system_module:set_entry(c3d.registry.entry("clamp_color"),function(color,limit)
                return CEIL(color*limit)/limit
            end)

            system_module:set_entry(c3d.registry.entry("environmental_override"),function(tp,val)
                BUS.triggers.overrides[tp] = val
            end)
        end

        sys:register()
    end
end