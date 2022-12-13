local mtl_decode = require("core.loaders.material.mtl")

return {add=function(BUS)

    return function()
        local material = plugin.new("c3d:object->material")

        function material.register_objects()
            local object_registry = c3d.registry.get_object_registry()
            local material_object = object_registry:new_entry("material")

            material_object:set_entry(c3d.registry.entry("get_texture"),function(this,material)
                return this.loaded_textures[material]
            end)

            material_object:define_decoder(".mtl",mtl_decode)

            material_object:constructor(function(path,texture_load_settings)
                local obj,textures = {},{}
                obj.loaded_textures = textures

                local materials = material_object:read_file(path)
                obj.material_types = materials

                for name,material in pairs(materials) do
                    if material.texture_path then
                        textures[name] = BUS.object.texture.new(
                            fs.combine(fs.getDir(path),material.texture_path),
                            texture_load_settings
                        )
                    end
                end

                return obj
            end)
        end

        material:register()
    end
end}