local timer = {}
local generic = require("common.generic")
local is_craftos = _HOST:find("CraftOS%-PC")

if is_craftos then config.set("mouse_move_throttle",1) end

return function(BUS)
    function timer.step()
        BUS.timer.last_delta = BUS.timer.temp_delta
        return BUS.timer.last_delta
    end

    function timer.getDelta()
        return BUS.timer.last_delta
    end

    function timer.sleep(time_seconds)
        if time_seconds > 0.05 then sleep(time_seconds)
        else
            generic.precise_sleep(time_seconds)
        end
    end

    function timer.getTime()
        if is_craftos then
            return os.epoch("nano")/1000000000
        else
            return os.epoch("utc")/1000
        end
    end

    function timer.getAverageDelta()
        local total = 0
        for k,v in ipairs(BUS.frames) do
            total = total + v.ft
        end
        return (total/#BUS.frames)/1000
    end

    function timer.getFPS()
        return #BUS.frames
    end

    return timer
end