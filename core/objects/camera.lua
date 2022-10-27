local object = require("core.object")

local translate_matrix        = require("core.3D.matrice.translate")
local euler_rotation_matrix   = require("core.3D.matrice.rotation_euler")
local quat_rotation_matrix    = require("core.3D.matrice.rotation_quaternion")
local lookat_transform_matrix = require("core.3D.matrice.lookat")

local matmul = require("core.3D.math.matmul")

return {add=function(BUS)

    local camera_object = {
        __index = object.new{
            set_position = function(this,x,y,z)
                this.position = translate_matrix(-x,-y,-z)
                this.transform = nil
                return this
            end,
            set_rotation = function(this,rx,ry,rz,w)
                if not w then
                    this.rotation = euler_rotation_matrix(-rx,-ry,-rz)
                else
                    this.rotation = quat_rotation_matrix(-rx,-ry,-rz,-w)
                end
                this.transform = nil
                return this
            end,
            set_transform = function(this,transform)
                this.transform = transform
                return this
            end,
            lookat_transform = function(this,fromx,fromy,fromz,atx,aty,atz)
                this.transform = lookat_transform_matrix(fromx,fromy,fromz,atx,aty,atz)
                return this
            end
        },__tostring=function() return "camera" end
    }

    return {new=function()
        local obj = {
            rotation = euler_rotation_matrix(0,0,0),
            position = translate_matrix(0,0,0)
        }

        return setmetatable(obj,camera_object):__build()
    end}
end}