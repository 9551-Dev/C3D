return function(BUS)

    local function grab_event_queue()
        return table.remove(BUS.events,1)
    end
    local function add_event_queue(...)
        BUS.events[#BUS.events+1] = table.pack(...)
    end

    return function()
        local event = plugin.new("c3d:module->event")

        function event.register_modules()
            local module_registry = c3d.registry.get_module_registry()
            local event_module    = module_registry:new_entry("event")

            event_module:set_entry(c3d.registry.entry("clear"),function()
                BUS.events = {}
            end)

            event_module:set_entry(c3d.registry.entry("poll"),function()
                return coroutine.wrap(function()
                    for i=1,#BUS.events do
                        local ev = grab_event_queue()
                        coroutine.yield(table.unpack(ev,1,ev.n))
                    end
                end)
            end)

            event_module:set_entry(c3d.registry.entry("push"),function(...)
                add_event_queue(...)
            end)

            event_module:set_entry(c3d.registry.entry("quit"),function(exit_status)
                add_event_queue("quit",exit_status)
            end)

            event_module:set_entry(c3d.registry.entry("wait"),function()
                while #BUS.events < 1 do
                    os.queueEvent("waiting")
                    os.pullEvent("waiting")
                end
                return grab_event_queue()
            end)
        end

        event:register()
    end
end
