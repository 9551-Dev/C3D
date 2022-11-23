local cimg2_decode = require("core.loaders.texture.cimg2")
local ppm_decode   = require("core.loaders.texture.ppm")
local nfp_decode   = require("core.loaders.texture.nfp")

local img_scale    = require("core.graphics.scale_image")

local empty = {}

return {add=function(BUS)

    return function()
        local texture = plugin.new("c3d:object->texture")

        function texture.register_objects()
            local object_registry = c3d.registry.get_object_registry()
            local texture_object  = object_registry:new_entry("texture")

            texture_object:set_entry(c3d.registry.entry("get_out"),function(this)
                return this.c3d.option_result
            end)
            texture_object:set_entry(c3d.registry.entry("sprite_sheet"),function(this,settings)
                return BUS.object.sprite_sheet.new(this,settings)
            end)
            texture_object:set_entry(c3d.registry.entry("scale_down"),function(this,factor)
                for i=1,#this.pixels do
                    local cur = this.pixels[i]

                    this.pixels[i]          = img_scale(cur,factor,cur.w,cur.h)
                    this.as_transparency[i] = img_scale(this.as_transparency[i],factor,cur.w,cur.h)
                end
                return this
            end)

            texture_object:define_decoder(".cimg2",cimg2_decode)
            texture_object:define_decoder(".ppm",ppm_decode)
            texture_object:define_decoder(".nfp",nfp_decode)
            
            texture_object:constructor(function(path,options)
                local option_result = {}
                local fin = {}

                local data = texture_object:read_file(path,BUS,options or {},option_result,fin)
                
                data.c3d = {}

                data.c3d.option_result = option_result
                fin.returns = data

                if options and options.mipmap_levels and options.mipmap_levels > 0 then
                    data.mipmap_levels  = options.mipmap_levels

                    for i=1,options.mipmap_levels or 1 do
                        local factor = 2^i
                        data.pixels[i+1]          = img_scale(data.pixels[1],         factor,data.w,data.h)
                        data.as_transparency[i+1] = img_scale(data.as_transparency[1],factor,data.w,data.h)
                    end
                else
                    data.mipmap_levels  = 0
                    data.misses_mipmaps = true
                end

                if options then
                    data.transparency_map = (options.transparency or empty).as_transparency
                end

                return data
            end)
        end

        texture:register()
    end
end}