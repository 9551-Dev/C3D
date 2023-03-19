return function(BUS)

    return function()
        local pipe = plugin.new("c3d:module->pipe")

        function pipe.on_init_finish()
            BUS.pipe.default = BUS.object.pipeline.new(BUS.pipe.default.id)
        end
        
        function pipe.register_modules()
            local module_registry = c3d.registry.get_module_registry()
            local pipe_module     = module_registry:new_entry("pipe")

            pipe_module:set_entry(c3d.registry.entry("new"),function(...)
                BUS.object.pipeline.new(...)
            end)

        end

        pipe:register()
    end
end