local object = require("core.object")
local tbl    = require("common.table_util")

local ceil = math.ceil

return {add=function(BUS)

    local sprite_sheet_object = {
        __index = object.new{
            make_animation=function(this,collumn,duration)
                return BUS.object.animated_texture.new(this,collumn,duration)
            end,
            get=function(this,x,y)
                return {
                    pixels=this.sprites[y][x],
                    w=this.sprite_width,
                    h=this.sprite_height
                }
            end
        },__tostring=function() return "sprite_sheet" end
    }

    return {new=function(texture,settings)
        local obj = {sprites=tbl.createNDarray(3)}

        local sprites = obj.sprites

        local sprite_w = settings.width  or settings.w
        local sprite_h = settings.height or settings.h
        local texture_pixels = texture.pixels

        obj.sprite_width  = sprite_w
        obj.sprite_height = sprite_h
        obj.sprites_x = ceil(texture.w/sprite_w)
        obj.sprites_y = ceil(texture.h/sprite_h)

        for x=1,texture.w do
            for y=1,texture.h do
                sprites[ceil(y/sprite_h)][ceil(x/sprite_w)][(y-1)%sprite_h+1][(x-1)%sprite_w+1] = texture_pixels[y][x]
            end
        end

        return setmetatable(obj,sprite_sheet_object):__build()
    end}
end}