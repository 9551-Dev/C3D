local run = require("core.uloop")
local generic = require("common.generic")

return {make=function(ENV,BUS,args)
    return coroutine.create(function()
        run(ENV.c3d,args)
        local runner = ENV.c3d.run()
        local bgs = BUS.graphics.stats

        while true do
            local frame_start = os.epoch("utc")
            runner()
            bgs.frames_drawn = bgs.frames_drawn + 1
            local current_time = os.epoch("utc")
            local frame_time = current_time-frame_start
            BUS.timer.temp_delta = frame_time

            BUS.frames[#BUS.frames+1] = {ft=frame_time,begin=frame_start}

            for k,v in ipairs(BUS.frames) do
                local t_diff = current_time-v.begin
                if t_diff > 1000 then
                    table.remove(BUS.frames,1)
                else break end
            end
        end
    end)
end}