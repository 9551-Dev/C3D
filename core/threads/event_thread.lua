local generic = require("common.generic")

local keypressed  = require("core.callbacks.keypressed")
local keyreleased = require("core.callbacks.keyreleased")
local textinput   = require("core.callbacks.textinput")

local mousemoved    = require("core.callbacks.mousemoved")
local mousepressed  = require("core.callbacks.mousepressed")
local mousereleased = require("core.callbacks.mousereleased")
local wheelmoved    = require("core.callbacks.wheelmoved")

local function unpack_ev(ev)
    return table.unpack(ev,1,ev.n)
end

return {make=function(ENV,BUS)

    BUS.log("   - Created event handler thread",BUS.log.success)
    BUS.log:dump()

    return coroutine.create(function()
        while true do
            local ev = table.pack(os.pullEventRaw())
            if ev[1] == "monitor_touch" and ev[2] == BUS.graphics.monitor then
                ev[1] = "mouse_click"
                ev[2] = 1
            end
            if generic.events_with_cords[ev[1]] and not (ev[1] == "mouse_move" and ev[3] == nil) then
                ev[3] = ev[3] - BUS.graphics.event_offset.x
                ev[4] = ev[4] - BUS.graphics.event_offset.y
            end

            if ev[1] == keypressed.ev then keypressed.run(BUS,ENV.c3d,unpack_ev(ev)) end
            if ev[1] == keyreleased.ev then keyreleased.run(BUS,ENV.c3d,unpack_ev(ev)) end
            if ev[1] == textinput.ev then textinput.run(BUS,ENV.c3d,unpack_ev(ev)) end

            if ev[1] == mousemoved.ev then mousemoved.run(BUS,ENV.c3d,unpack_ev(ev)) end
            if ev[1] == mousepressed.ev then mousepressed.run(BUS,ENV.c3d,unpack_ev(ev)) end
            if ev[1] == mousereleased.ev then mousereleased.run(BUS,ENV.c3d,unpack_ev(ev)) end
            if ev[1] == wheelmoved.ev then wheelmoved.run(BUS,ENV.c3d,unpack_ev(ev)) end

            if ev[1] == "mouse_drag" then mousemoved:check_change(BUS,ENV.c3d,ev[3],ev[4]) end

            if ENV.c3d.on_event then ENV.c3d.on_event(unpack_ev(ev)) end

            local listeners = {}
            for k,v in pairs(BUS.triggers.event_listeners) do
                local filter = v.filter
                if type(filter) == "string" then filter = {[v.filter]=true} end
                if filter[ev[1]] or filter == ev[1] or (not next(filter)) then
                    v.code(table.unpack(ev,_G.type(v.filter) ~= "table" and 2 or 1,ev.n))
                    table.insert(listeners,v.finish)
                end
            end
            for k,v in pairs(listeners) do v() end
        end
    end)
end}