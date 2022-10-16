local generic = require("common.generic")
local tbl = require("common.table_util")

local mouse_moved = require("core.callbacks.mousemoved")

local click_time_frame = 400
local clicks = {}

return {ev="mouse_click",run=function(BUS,caller,ev,btn,x,y)
    mouse_moved:check_change(BUS,caller,x,y)

    local c_time = os.epoch("utc")

    clicks[generic.uuid4()] = {c_time,btn,x,y}
    local registered = tbl.createNDarray(2)
    for k,v in pairs(clicks) do
        if c_time-v[1] < click_time_frame then
            local loc = registered[v[3]][v[4]]
            if loc[v[2]] then
                loc[v[2]] = loc[v[2]] + 1
                clicks[k] = {c_time,v[2],v[3],v[4]}
            else loc[v[2]] = 1 end
        end
    end

    BUS.events[#BUS.events+1] = {"mousepressed",x*2,y*3,btn,false,registered[x][y][btn]}
    if type(caller.mousepressed) == "function" then
        caller.mousepressed(x*2,y*3,btn,false,registered[x][y][btn])
    end
end}