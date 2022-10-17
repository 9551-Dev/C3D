local object = require("core.object")

local translate_matrix = require("core.3D.matrice.translate")
local rotation_matrix  = require("core.3D.matrice.rotation")

return {add=function(BUS)

    local camera_object = {
        __index = object.new{
            set_position = function(this,x,y,z)
                this.position = translate_matrix(-x,y,-z)
                return this
            end,
            set_rotation = function(this,rx,ry,rz)
                this.rotation = rotation_matrix(-rx,-ry,-rz)
                return this
            end
        },__tostring=function() return "camera" end
    }

    return {new=function()
        return setmetatable({},camera_object):__build()
    end}
end}