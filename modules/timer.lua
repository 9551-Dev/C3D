local generic = require("common.generic")
local is_craftos = _HOST:find("CraftOS%-PC")

if is_craftos then config.set("mouse_move_throttle",1) end

return function(BUS)
    return function()
        local timer = plugin.new("c3d:timer")

        function timer.register_modules()
            local module_registry = c3d.registry.get_module_registry()
            local timer_module    = module_registry:new_entry("timer")

            timer_module:set_entry(c3d.registry.entry("step"),function()
                BUS.timer.last_delta = BUS.timer.temp_delta
                return BUS.timer.last_delta/1000
            end)

            timer_module:set_entry(c3d.registry.entry("get_delta"),function()
                return BUS.timer.last_delta
            end)

            timer_module:set_entry(c3d.registry.entry("sleep"),function(time_seconds)
                if time_seconds > 0.05 then sleep(time_seconds)
                else
                    generic.precise_sleep(time_seconds)
                end
            end)

            timer_module:set_entry(c3d.registry.entry("get_time"),function()
                if is_craftos then
                    return os.epoch("nano")/1000000000
                else
                    return os.epoch("utc")/1000
                end
            end)

            timer_module:set_entry(c3d.registry.entry("get_average_delta"),function()
                local total = 0
                for k,v in ipairs(BUS.frames) do
                    total = total + v.ft
                end
                return (total/#BUS.frames)/1000
            end)

            timer_module:set_entry(c3d.registry.entry("getFPS"),function()
                return #BUS.frames
            end)
        end

        timer:register()
    end
end