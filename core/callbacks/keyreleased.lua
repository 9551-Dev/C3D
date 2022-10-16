return {ev="key_up",run=function(BUS,caller,ev,key_code)
    local code = keys.getName(key_code)
    BUS.events[#BUS.events+1] = {"keyreleased",code,code}
    if type(caller.keyreleased) == "function" then
        caller.keyreleased(code,code)
    end
end}