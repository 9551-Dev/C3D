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
        if not texture_pixels then
            return colors.black,true,frag.instance
        end

        local w = texture_pixels.w
        local h = texture_pixels.h
        local t = (tex.transparency_map or empty)[level]

        local z = frag.z_correct
        local x =   MAX(1,MIN(CEIL(frag.tx*z*w),w))
        local y = h-MAX(1,MIN(CEIL(frag.ty*z*h),h))+1

        local is_transparent = false
        if t and t[y] then is_transparent = t[y][x] end

        local color_final
        if texture_pixels and texture_pixels[y] then
            color_final = texture_pixels[y][x]
        end

        frag.texture_x,frag.texture_y = x,y

        return color_final,not color_final or is_transparent,frag.instance
    end

    return frag.color or colors.red,false,frag.instance
end

return function(fs)
    if fs then return fs end

    return default_fragment
end
