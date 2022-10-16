local keyboard = {}

return function(BUS)
    function keyboard.getKeyFromScancode(scancode)
        return scancode
    end
    function keyboard.getScancodeFromkey(key)
        return key
    end

    function keyboard.getKeyRepeat()
        return BUS.keyboard.key_reapeat
    end
    function keyboard.setKeyRepeat(enable)
        BUS.keyboard.key_reapeat = enable
    end

    function keyboard.hasScreenKeyboard()
        return false
    end

    function keyboard.hasTextInput()
        return BUS.keyboard.textinput
    end
    function keyboard.setTextInput(enable)
        BUS.keyboard.setinput = enable
    end

    function keyboard.isDown(...)
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