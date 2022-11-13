local cimg2_decode = require("core.loaders.texture.cimg2")
local ppm_decode   = require("core.loaders.texture.ppm")
local nfp_decode   = require("core.loaders.texture.nfp")

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

                return data
            end)
        end

        texture:register()
    end
end}