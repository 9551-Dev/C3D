local object = require("core.object")

return {add=function(BUS)

    local generic_shape_object = {
        __index = object.new{
            add_param=function(self,type,val)
                self[type] = val
                return self
            end,
            add_prop=function(self,type,val)
                self[type] = val
                return self
            end,
            push=function(self)
                return BUS.object.scene_obj.new(self)
            end
        },__tostring=function() return "generic_shape" end
    }

    return {new=function(geometry)
        return setmetatable(geometry,generic_shape_object):__build()
    end}
end}