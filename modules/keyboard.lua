return function(BUS)

    return function()
        local keyboard = plugin.new("keyboard")

        function keyboard.register_modules()
            local module_registry = c3d.registry.get_module_registry()
            local keyboard_module = module_registry:new_entry("keyboard")
            
            keyboard_module:set_entry(c3d.registry.entry("has_text_input"),function()
                return BUS.keyboard.textinput
            end)
            keyboard_module:set_entry(c3d.registry.entry("set_text_input"),function(enable)
                BUS.keyboard.setinput = enable
            end)

            keyboard_module:set_entry(c3d.registry.entry("is_down"),function(...)
                local key_list = {...}
                for k,key in pairs(key_list) do
                    local held = BUS.keyboard.pressed_keys[keys[key]]
                    if not (held and held[1]) then
                        return false
                    end
                end
                return true
            end)
        end

        keyboard:register()
    end
end
