return {add=function(BUS)
    return function()
        local generic_shape = plugin.new("c3d:object->generic_shape")

        function generic_shape.register_objects()
            local object_registry      = c3d.registry.get_object_registry()
            local generic_shape_object = object_registry:new_entry("generic_shape")

            generic_shape_object:set_entry(c3d.registry.entry("add_param"),function(self,type,val)
                self[type] = val
                return self
            end)
            generic_shape_object:set_entry(c3d.registry.entry("add_prop"),function(self,type,val)
                self[type] = val
                return self
            end)
            generic_shape_object:set_entry(c3d.registry.entry("push"),function(self)
                return BUS.object.scene_object.new(self)
            end)

            generic_shape_object:constructor(function(geometry)
                return geometry
            end)
        end

        generic_shape:register()
    end
end}