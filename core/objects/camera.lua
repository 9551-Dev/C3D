local object = require("core.object")

local translate_matrix      = require("core.3D.matrice.translate")
local euler_rotation_matrix = require("core.3D.matrice.rotation_euler")
local quat_rotation_matrix  = require("core.3D.matrice.rotation_quaternion")

return {add=function(BUS)

    local camera_object = {
        __index = object.new{
            set_position = function(this,x,y,z)
                this.position = translate_matrix(-x,y,-z)
                return this
            end,
            set_rotation = function(this,rx,ry,rz,w)
                if not w then
                    this.rotation = euler_rotation_matrix(-rx,-ry,-rz)
                else
                    this.rotation = quat_rotation_matrix(-rx,-ry,-rz,-w)
                end
                return this
            end,
        },__tostring=function() return "camera" end
    }

    return {new=function()
        return setmetatable({},camera_object):__build()
    end}
end}