local MAX,MIN,CEIL = math.max,math.min,math.ceil

return function(fs)
    if fs then return fs end

    return function(frag)
        if frag.texture then
            local z = frag.z_correct
            local x = MAX(1,MIN(CEIL(frag.tx*z*frag.tex.w),frag.tex.w))
            local y = MAX(1,MIN(CEIL(frag.ty*z*frag.tex.h),frag.tex.h))

            return frag.texture[y][x]
        end

        return frag.color or colors.red
    end
end