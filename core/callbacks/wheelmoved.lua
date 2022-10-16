local mouse_moved = require("core.callbacks.mousemoved")

return {ev="mouse_scroll",run=function(BUS,caller,ev,dir,x,y)
    local k_list = BUS.keyboard.pressed_keys

    mouse_moved:check_change(BUS,caller,x,y)

    local shift_held = k_list[keys.leftShift] or k_list[keys.rightShift]

    BUS.events[#BUS.events+1] = {"wheelmoved",
        shift_held and 0-dir or 0,
        shift_held and 0     or 0-dir
    }

    if type(caller.wheelmoved) == "function" then
        caller.wheelmoved(
            shift_held and 0-dir or 0,
            shift_held and 0     or 0-dir
        )
    end
end}