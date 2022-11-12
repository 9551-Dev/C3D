local tbl_util = require("common.table_util")
local generic  = require("common.generic")

local scale_matrice     = require("core.3D.matrice.scale")
local euler_rot_matrice = require("core.3D.matrice.rotation_euler")
local quat_rot_matrice  = require("core.3D.matrice.rotation_quaternion")
local trans_matrice     = require("core.3D.matrice.translate")

return {add=function(BUS)

    return function()
        local scene_object = plugin.new("c3d:object->scene_object")

        function scene_object.register_objects()
            local object_registry     = c3d.registry.get_object_registry()
            local scene_object_object = object_registry:new_entry("scene_object")

            scene_object_object:set_entry(c3d.registry.entry("resize"),function(self,sx,sy,sz)
                self.properties.scale_mat = scale_matrice(sx,sy,sz)
                return self
            end)
            scene_object_object:set_entry(c3d.registry.entry("set_size"),function(self,sx,sy,sz)
                self.properties.scale_mat = scale_matrice(sx,sy,sz)
                return self
            end)
            scene_object_object:set_entry(c3d.registry.entry("reposition"),function(self,x,y,z)
                self.properties.pos_mat = trans_matrice(x,y,z)
                return self
            end)
            scene_object_object:set_entry(c3d.registry.entry("set_position"),function(self,x,y,z)
                self.properties.pos_mat = trans_matrice(x,y,z)
                return self
            end)
            scene_object_object:set_entry(c3d.registry.entry("set_rotation"),function(self,rx,ry,rz,w)
                if not w then
                    self.properties.rotation_mat = euler_rot_matrice(rx,ry,rz)
                else
                    self.properties.rotation_mat = quat_rot_matrice(rx,ry,rz,w)
                end
                return self
            end)
            scene_object_object:set_entry(c3d.registry.entry("remove"),function(self)
                BUS.scene[self.ID] = nil
                return self
            end)
            scene_object_object:set_entry(c3d.registry.entry("set_frag_shader"),function(self,f)
                self.effects.fs = f
                return self
            end)
            scene_object_object:set_entry(c3d.registry.entry("set_vertex_shader"),function(self,f)
                self.effects.vs = f
                return self
            end)
            scene_object_object:set_entry(c3d.registry.entry("set_geometry_shader"),function(self,f)
                self.effects.gs = f
                return self
            end)
            scene_object_object:set_entry(c3d.registry.entry("clone"),function(self)
                return BUS.object.scene_object.new(tbl_util.deepcopy(self))
            end)

            scene_object_object:constructor(function(geometry)
                local id = generic.uuid4()

                geometry.properties = {
                    scale_mat=scale_matrice(1,1,1),
                    rotation_mat=euler_rot_matrice(0,0,0),
                    pos_mat=trans_matrice(0,0,0)
                }

                if not geometry.effects then geometry.effects = {} end

                geometry.ID = id

                BUS.scene[id] = geometry

                return geometry
            end)
        end

        scene_object:register()
    end
end}