local keyboard = {}

return function(BUS)
    function keyboard.get_key_repeat()
        return BUS.keyboard.key_reapeat
    end
    function keyboard.set_key_repeat(enable)
        BUS.keyboard.key_reapeat = enable
    end

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

    keyboard.isScancodeDown = keyboard.isDown

    return keyboard
end