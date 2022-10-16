return {ev="char",run=function(BUS,caller,ev,char)
    if BUS.keyboard.textinput then
        BUS.events[#BUS.events+1] = {"textinput",char}

        if type(caller.textinput) == "function" then
            caller.textinput(char)
        end
    end
end}