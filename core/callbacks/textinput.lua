return {ev="char",run=function(BUS,caller,ev,char)
    if BUS.keyboard.textinput then
        BUS.events[#BUS.events+1] = {"textinput",char}

        if type(caller.textinput) == "function" or type(BUS.triggers.overrides.textinput) == "function" then
            (BUS.triggers.overrides.textinput or caller.textinput)(char)
        end
    end
end}