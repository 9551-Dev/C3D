local MAX,MIN,CEIL = math.max,math.min,math.ceil

local function default_fragment(frag)
    if frag.texture then
        local tex = frag.tex
        local w = tex.w
        local h = tex.h

        local z = frag.z_correct
        local x = MAX(1,MIN(CEIL(frag.tx*z*w),w))
        local y = MAX(1,MIN(CEIL(frag.ty*z*h),h))

        return frag.texture[h-y+1][x]
    end

    return frag.color or colors.red
end

return function(fs)
    if fs then return fs end

    return default_fragment
end