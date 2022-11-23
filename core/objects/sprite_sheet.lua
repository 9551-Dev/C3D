local tbl    = require("common.table_util")

local ceil = math.ceil

return {add=function(BUS)

    return function()
        local sprite_sheet = plugin.new("c3d:object->sprite_sheet")

        function sprite_sheet.register_objects()
            local object_registry     = c3d.registry.get_object_registry()
            local sprite_sheet_object = object_registry:new_entry("sprite_sheet")

            sprite_sheet_object:set_entry(c3d.registry.entry("make_animation"),function(this,collumn,duration)
                return BUS.object.animated_texture.new(this,collumn,duration)
            end)
            sprite_sheet_object:set_entry(c3d.registry.entry("get"),function(this,x,y)
                return {
                    pixels=this.sprites[y][x],
                    w=this.sprite_width,
                    h=this.sprite_height
                }
            end)

            sprite_sheet_object:constructor(function(texture,settings)
                local obj = {sprites=tbl.createNDarray(2),tex=texture}

                local sprites = obj.sprites

                local sprite_w = settings.width  or settings.w
                local sprite_h = settings.height or settings.h
                local texture_pixels  = texture.pixels
                local transparency    = texture.transparency_map
                local as_transparency = texture.as_transparency

                obj.sprite_width  = sprite_w
                obj.sprite_height = sprite_h
                obj.sprites_x = ceil(texture.w/sprite_w)
                obj.sprites_y = ceil(texture.h/sprite_h)

                for mipmap=1,texture.misses_mipmaps and 1 or texture.mipmap_levels do

                    local current_texture         = texture_pixels [mipmap]
                    local current_as_transparency = as_transparency[mipmap]


                    local sprt_w = sprite_w/2^(mipmap-1)
                    local sprt_h = sprite_h/2^(mipmap-1)

                    for y=1,current_texture.h do
                        local layer = sprites[ceil(y/sprt_h)]
                        for x=1,current_texture.w do
                            if not layer[ceil(x/sprt_w)].pixels then
                                layer[ceil(x/sprt_w)] = {
                                    pixels={},
                                    transparency_map={},
                                    as_transparency={}
                                }
                            end

                            if not layer[ceil(x/sprt_w)].pixels[mipmap] then
                                layer[ceil(x/sprt_w)].pixels[mipmap]          = tbl.createNDarray(2,{w=sprt_w,h=sprt_h})
                                layer[ceil(x/sprt_w)].as_transparency[mipmap] = tbl.createNDarray(2,{w=sprt_w,h=sprt_h})
                                if transparency then
                                    layer[ceil(x/sprt_w)].transparency_map[mipmap] = tbl.createNDarray(2,{w=sprt_w,h=sprt_h})
                                end
                            end

                            layer[ceil(x/sprt_w)].pixels         [mipmap][(y-1)%sprt_h+1][(x-1)%sprt_w+1] = current_texture        [y][x]
                            layer[ceil(x/sprt_w)].as_transparency[mipmap][(y-1)%sprt_h+1][(x-1)%sprt_w+1] = current_as_transparency[y][x]

                            if transparency then
                                layer[ceil(x/sprt_w)].transparency_map[mipmap][(y-1)%sprt_h+1][(x-1)%sprt_w+1] = transparency[mipmap][y][x]
                            end
                        end
                    end
                end

                return obj
            end)
        end

        sprite_sheet:register()
    end
end}