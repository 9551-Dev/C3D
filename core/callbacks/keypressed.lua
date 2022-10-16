return {ev="key",run=function(BUS,caller,ev,key_code,is_held)
    local code = keys.getName(key_code)
    if not is_held or BUS.keyboard.key_reapeat then
        BUS.events[#BUS.events+1] = {"keypressed",code,code,is_held}
        if type(caller.keypressed) == "function" then
            caller.keypressed(code,code,is_held)
        end
    end
end}