return {build=function(BUS)
    local buff
    local types = {
        {x=1,  y=0, const = 7/16},
        {x=-1, y=1, const = 3/16},
        {x=0,  y=1, const = 5/16},
        {x=1,  y=1, const = 1/16}
    }

    return {dither=function(old,r,g,b,x,y)
        if not buff then buff = BUS.graphics.buffer end
        local err_r = old[1] - r
        local err_g = old[2] - g
        local err_b = old[3] - b

        for i=1,4 do
            local tp = types[i]
            local const = tp.const
            local t = buff[y+tp.y][x+tp.x]

            if t then

                t[1] = t[1] + err_r * const
                t[2] = t[2] + err_g * const
                t[3] = t[3] + err_b * const
            end
        end
    end}
end}
