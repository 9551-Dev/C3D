local MAX,MIN,CEIL,LOG = math.max,math.min,math.ceil,math.log
local empty = {}

local function default_fragment(frag)
    if frag.texture then
        local tex = frag.tex

        local level = 1
        if not tex.misses_mipmaps then
            level = MIN((CEIL(LOG(frag.mipmap_level+1,2))),tex.mipmap_levels-1)
        end

        local texture_pixels = frag.texture[level]

        local w = texture_pixels.w
        local h = texture_pixels.h
        local t = (tex.transparency_map or empty)[level]

        local z = frag.z_correct
        local x = MAX(1,MIN(CEIL(frag.tx*z*w),w))
        local y = MAX(1,MIN(CEIL(frag.ty*z*h),h))

        local is_transparent = false
        if t then is_transparent = t[h-y+1][x] end

        return texture_pixels[h-y+1][x],is_transparent
    end

    return frag.color or colors.red
end

return function(fs)
    if fs then return fs end

    return default_fragment
end