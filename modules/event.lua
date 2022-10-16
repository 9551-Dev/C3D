local event = {}

return function(BUS)

    local function grab_event_queue()
        return table.remove(BUS.events,1)
    end
    local function add_event_queue(...)
        BUS.events[#BUS.events+1] = table.pack(...)
    end

    function event.clear()
        BUS.events = {}
    end

    function event.poll()
        return coroutine.wrap(function()
            for i=1,#BUS.events do
                local ev = grab_event_queue()
                coroutine.yield(table.unpack(ev,1,ev.n))
            end
        end)
    end

    function event.pump() end

    function event.push(...)
        add_event_queue(...)
    end

    function event.quit(exit_status)
        add_event_queue("quit",exit_status)
    end

    function event.wait()
        while #BUS.events < 1 do
            os.queueEvent("yield")
            os.pullEvent("yield")
        end
        return grab_event_queue()
    end

    return event
end