local object = require("core.object")

local scale_matrice = require("core.3D.matrice.scale")
local rot_matrice   = require("core.3D.matrice.rotation")
local trans_matrice = require("core.3D.matrice.translate")

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
            set_rotation=function(self,rx,ry,rz)
                self.properties.rotation_mat = rot_matrice(rx,ry,rz)
                return self
            end,
            remove=function(self)
                BUS.scene[self.ID] = nil
                return self
            end,
            set_pixel_shader=function(self,f)
                self.effects.ps = f
                return self
            end,
            set_vertex_shader=function(self,f)
                self.effects.vs = f
                return self
            end,
            set_geometry_shader=function(self,f)
                self.effects.gs = f
                return self
            end
        },__tostring=function() return "scene_object" end
    }

    return {new=function(geometry)

        local id = tostring({})

        geometry.properties = {
            scale_mat=scale_matrice(1,1,1),
            rotation_mat=rot_matrice(0,0,0),
            pos_mat=trans_matrice(0,0,0)
        }

        if not geometry.effects then geometry.effects = {} end

        geometry.ID = id

        BUS.scene[id] = geometry

        return setmetatable(geometry,geometry_object):__build()
    end}
end}