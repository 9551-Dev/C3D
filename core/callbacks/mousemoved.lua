return {ev="mouse_move",run=function(BUS,caller,ev,_,x,y)
    if x ~= nil then
        local change_x = x - (BUS.mouse.last_x or 0)
        local change_y = y - (BUS.mouse.last_y or 0)
        BUS.events[#BUS.events+1] = {"mousemoved",x*2,y*3,change_x,change_y,false}
        BUS.mouse.last_x,BUS.mouse.last_y = x,y
        if type(caller.mousemoved) == "function" then
            caller.mousemoved(x*2,y*3,change_x,change_y,false)
        end
    end
end,check_change=function(self,BUS,caller,x,y)
    if x ~= BUS.mouse.last_x or y ~= BUS.mouse.last_y then
        self.run(BUS,caller,"mouse_move",_,x,y)
    end
end}
