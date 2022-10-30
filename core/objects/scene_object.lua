local object   = require("core.object")
local tbl_util = require("common.table_util")
local generic  = require("common.generic")

local scale_matrice     = require("core.3D.matrice.scale")
local euler_rot_matrice = require("core.3D.matrice.rotation_euler")
local quat_rot_matrice  = require("core.3D.matrice.rotation_quaternion")
local trans_matrice     = require("core.3D.matrice.translate")

return {add=function(BUS)

    local geometry_object = {
        __index = object.new{
            resize=function(self,sx,sy,sz)
                self.properties.scale_mat = scale_matrice(sx,sy,sz)
                return self
            end,
            set_size=function(self,sx,sy,sz)
                self.properties.scale_mat = scale_matrice(sx,sy,sz)
                return self
            end,
            reposition=function(self,x,y,z)
                self.properties.pos_mat = trans_matrice(x,y,z)
                return self
            end,
            set_position=function(self,x,y,z)
                self.properties.pos_mat = trans_matrice(x,y,z)
                return self
            end,
            set_rotation=function(self,rx,ry,rz,w)
                if not w then
                    self.properties.rotation_mat = euler_rot_matrice(rx,ry,rz)
                else
                    self.properties.rotation_mat = quat_rot_matrice(rx,ry,rz,w)
                end
                return self
            end,
            remove=function(self)
                BUS.scene[self.ID] = nil
                return self
            end,
            set_frag_shader=function(self,f)
                self.effects.fs = f
                return self
            end,
            set_vertex_shader=function(self,f)
                self.effects.vs = f
                return self
            end,
            set_geometry_shader=function(self,f)
                self.effects.gs = f
                return self
            end,
            clone=function(this)
                return BUS.object.scene_obj.new(tbl_util.deepcopy(this))
            end
        },__tostring=function() return "scene_object" end
    }

    return {new=function(geometry)

        local id = generic.uuid4()

        geometry.properties = {
            scale_mat=scale_matrice(1,1,1),
            rotation_mat=euler_rot_matrice(0,0,0),
            pos_mat=trans_matrice(0,0,0)
        }

        if not geometry.effects then geometry.effects = {} end

        geometry.ID = id

        BUS.scene[id] = geometry

        return setmetatable(geometry,geometry_object):__build()
    end}
end}