return function(BUS)
    return function()
        local palette = plugin.new("c3d:module->palette")

        function palette.register_modules()
            local module_registry = c3d.registry.get_module_registry()
            local palette_module  = module_registry:new_entry("palette")

            palette_module:set_entry(c3d.registry.entry("new"),function(pal)
                return BUS.object.palette.new(pal)
            end)
        end

        palette:register()
    end
end