local object = require("core.object")

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
            
            texture_object:constructor(function(path,options)
                local extension = path:match("^.+(%..+)$")
                local file_path = fs.combine(BUS.instance.scenedir,path)

                package.path = BUS.instance.libpak
                local parser = require("core.loaders.texture" .. extension)
                package.path = BUS.instance.scenepak

                local option_result = {}
                local fin = {}
                local data = parser.read(BUS,file_path,options or {},option_result,fin)
                data.c3d = {}

                data.c3d.option_result = option_result
                fin.returns = data

                return data
            end)
        end

        texture:register()
    end
end}