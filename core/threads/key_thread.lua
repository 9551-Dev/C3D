return {make=function(ENV,BUS)
    return coroutine.create(function()
        while true do
            while true do
                local name,key,held = os.pullEvent()
                if name == "key" then BUS.keyboard.pressed_keys[key] = {true,held} end
                if name == "key_up" then BUS.keyboard.pressed_keys[key] = nil end
                if name == "mouse_click" then BUS.mouse.held[key] = true end
                if name == "mouse_up" then BUS.mouse.held[key] = nil end
            end
        end
    end)
end}