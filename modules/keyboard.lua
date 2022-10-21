local keyboard = {}

return function(BUS)

    function keyboard.has_text_input()
        return BUS.keyboard.textinput
    end
    function keyboard.set_text_input(enable)
        BUS.keyboard.setinput = enable
    end

    function keyboard.is_down(...)
        local key_list = {...}
        for k,key in pairs(key_list) do
            local held = BUS.keyboard.pressed_keys[keys[key]]
            if not (held and held[1]) then
                return false
            end
        end
        return true
    end

    return keyboard
end
