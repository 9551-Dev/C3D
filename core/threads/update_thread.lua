local run = require("core.uloop")

return {make=function(ENV,BUS,args)

    BUS.log("   - Created main update thread",BUS.log.success)
    BUS.log:dump()

    return coroutine.create(function()
        run(BUS.triggers.overrides.c3d or ENV.c3d,args)
        local runner = (BUS.triggers.overrides.run or ENV.c3d.run)()
        local bgs  = BUS.graphics.stats
        local bsys = BUS.sys

        local function generate_frame()
            local frame_start = os.epoch("utc")

            bsys.run_time = frame_start - bsys.init_time

            for k,v in pairs(BUS.animated_texture.instances) do
                if v.running then v:__update() end
            end

            local state = runner()
            if state then BUS.running = false end

            for k,v in pairs(BUS.mem) do v.n = 0 end

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

        BUS.c3d.generate_frame = generate_frame

        while true do
            if BUS.sys.autorender then
                generate_frame()
            else sleep(0.1) end
            BUS.plugin_internal.wake_trigger("post_frame",BUS.graphics.stats.frames_drawn)
        end
    end)
end}