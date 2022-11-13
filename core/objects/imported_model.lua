local obj_decode = require("core.loaders.imported_model.obj")

return {add=function(BUS)

    return function()
        local imported_model = plugin.new("c3d:object->imported_model")

        function imported_model.register_objects()
            local object_registry       = c3d.registry.get_object_registry()
            local imported_model_object = object_registry:new_entry("imported_model")

            imported_model_object:set_entry(c3d.registry.entry("make_geometry"),function(this,scale)
                scale = scale or 1
                local ver = this.DATA.geometry.vertices
                for i=1,#ver do
                    ver[i] = ver[i]*scale
                end
                return BUS.object.generic_shape.new(this.DATA)
            end)

            imported_model_object:define_decoder(".obj",obj_decode)

            imported_model_object:constructor(function(path)
                local obj = {}

                obj.DATA = imported_model_object:read_file(path)

                return obj
            end)
        end

        imported_model:register()
    end
end}