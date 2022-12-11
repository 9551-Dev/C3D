return {ev="key",run=function(BUS,caller,ev,key_code,is_held)
    local code = keys.getName(key_code)
    if not is_held or BUS.keyboard.key_reapeat then
        BUS.events[#BUS.events+1] = {"keypressed",code,code,is_held}
        if type(caller.keypressed) == "function" or type(BUS.triggers.overrides.keypressed) == "function" then
            (BUS.triggers.overrides.keypressed or caller.keypressed)(code,is_held)
        end
    end
end}
