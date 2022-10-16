local sys = {}

local CEIL = math.ceil

return function(BUS)

    function sys.get_bus()
        return BUS
    end

    function sys.fps_limit(limit)
        BUS.sys.frame_time_min = 1/limit
    end

    function sys.clamp_color(color,limit)
        return CEIL(color*limit)/limit
    end

    return sys
end