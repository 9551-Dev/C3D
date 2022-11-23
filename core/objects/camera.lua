local camera_translate_matrix = require("core.3D.matrice.camera_translate")
local euler_rotation_matrix   = require("core.3D.matrice.rotation_euler")
local quat_rotation_matrix    = require("core.3D.matrice.rotation_quaternion")
local lookat_transform_matrix = require("core.3D.matrice.lookat")

return {add=function(BUS)

    return function()
        local camera = plugin.new("c3d:object->camera")

        function camera.register_objects()
            local object_registry = c3d.registry.get_object_registry()
            local camera_object   = object_registry:new_entry("camera")

            camera_object:set_entry(c3d.registry.entry("set_position"),function(this,x,y,z)
                this.position = camera_translate_matrix(-x,-y,-z)
                this.transform = nil
                return this
            end)
            camera_object:set_entry(c3d.registry.entry("set_rotation"),function(this,rx,ry,rz,w)
                if not w then
                    this.rotation = euler_rotation_matrix(-rx,-ry,-rz)
                else
                    this.rotation = quat_rotation_matrix(-rx,-ry,-rz,-w)
                end
                this.transform = nil
                return this
            end)
            camera_object:set_entry(c3d.registry.entry("set_transform"),function(this,transform)
                this.transform = transform
                return this
            end)
            camera_object:set_entry(c3d.registry.entry("lookat_transform"),function(this,fromx,fromy,fromz,atx,aty,atz,near_plane_offset)
                this.transform = lookat_transform_matrix(fromx,fromy,fromz,atx,aty,atz,near_plane_offset)
                return this
            end)

            camera_object:constructor(function()
                return {
                    rotation = euler_rotation_matrix(0,0,0),
                    position = camera_translate_matrix(0,0,0)
                }
            end)
        end

        camera:register()
    end
end}