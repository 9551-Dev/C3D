local sys = {}

local CEIL = math.ceil

return function(BUS)

    function sys.get_bus()
        return BUS
    end

    function sys.quantize(enable)
        BUS.sys.quantize = enable
    end

    function sys.dither(enable)
        BUS.sys.dither = enable
    end

    function sys.fps_limit(limit)
        BUS.sys.frame_time_min = 1/limit
    end

    function sys.clamp_color(color,limit)
        return CEIL(color*limit)/limit
    end

    function sys.reserve_color(r,g,b)
        local res = BUS.sys.reserved_colors
        res[#res+1] = {r,g,b}
    end

    function sys.pop_reserved_color()
        local res = BUS.sys.reserved_colors
        res[#res] = nil
    end

    function sys.get_reserved_colors()
        return BUS.sys.reserved_colors
    end

    function sys.remove_reserved_colors()
        BUS.sys.reserved_colors = {}
    end

    function sys.reserve_spot(n,r,g,b)
        local sp = BUS.sys.reserved_spots
        sp[#sp+1] = {2^n,{r,g,b}}
    end

    function sys.pop_reserved_spot()
        local sp = BUS.sys.reserved_spots
        sp[#sp] = nil
    end

    function sys.remove_reserved_spots()
        BUS.sys.reserved_spots = {}
    end

    return sys
end