local matmul = require("core.3D.math.matmul")

local RANDOM,MAX,MIN,CEIL = math.random,math.max,math.min,math.ceil

local empty = {}

return function(BUS)

    return function()
        local shader = plugin.new("c3d:module->shader")

        function shader.register_modules()
            local module_registry = c3d.registry.get_module_registry()
            local shader_module   = module_registry:new_entry("shader")
            
            local default = {}
            local vertex = {}
            local frag = {}

            function default.vertex(x,y,z,w,properties,scale,rot,pos,per,cam_transform,cam_position,cam_rotation)

                local sc1,sc2,sc3,sc4    = matmul(x,y,z,w,scale)
                local rx1,ry2,ry3,ry4    = matmul(sc1,sc2,sc3,sc4,rot)
                local tl1,tl2,tl3,tl4    = matmul(rx1,ry2,ry3,ry4,pos)
                local ct1,ct2,ct3,ct4
                if cam_transform then
                    ct1,ct2,ct3,ct4 = matmul(tl1,tl2,tl3,tl4,cam_transform)
                else
                    local cp1,cp2,cp3,cp4 = matmul(tl1,tl2,tl3,tl4,cam_position)
                    ct1,ct2,ct3,ct4 = matmul(cp1,cp2,cp3,cp4,cam_rotation)
                end

                return matmul(ct1,ct2,ct3,ct4,per)
            end

            function default.frag(frag)
                if frag.texture then
                    local tex = frag.tex
                    local w = tex.w
                    local h = tex.h
                    local t = (tex.transparency_map or empty).as_transparency
            
                    local z = frag.z_correct
                    local x = MAX(1,MIN(CEIL(frag.tx*z*w),w))
                    local y = MAX(1,MIN(CEIL(frag.ty*z*h),h))
            
                    local is_visible = true
                    if t then is_visible = t[h-y+1][x] end
            
                    return frag.texture[h-y+1][x],is_visible
                end
            
                return frag.color or colors.red,true
            end

            function default.geometry(triangle)
                return triangle
            end

            function frag.noise()
                return 2^(RANDOM(0,1)*15)
            end

            function vertex.skybox(x,y,z,w,properties,scale,rot,pos,per,cam_transform,cam_position,cam_rotation)
                local sc1,sc2,sc3,sc4    = matmul(x,y,z,w,scale)
                local rx1,ry2,ry3,ry4    = matmul(sc1,sc2,sc3,sc4,rot)
                local ct1,ct2,ct3,ct4
                if cam_transform then
                    ct1,ct2,ct3,ct4 = matmul(rx1,ry2,ry3,ry4,{
                        cam_transform[1],cam_transform[2], cam_transform[3], cam_transform[4],
                        cam_transform[5],cam_transform[6], cam_transform[7], cam_transform[8],
                        cam_transform[9],cam_transform[10],cam_transform[11],cam_transform[12],
                        0,0,0,1
                    })
                else
                    ct1,ct2,ct3,ct4 = matmul(matmul(rx1,ry2,ry3,ry4,cam_position),cam_rotation)
                end
                return matmul(ct1,ct2,ct3,ct4,per)
            end

            shader_module:set_entry(c3d.registry.entry("default"),default)
            shader_module:set_entry(c3d.registry.entry("vertex") ,vertex)
            shader_module:set_entry(c3d.registry.entry("frag")   ,frag)
        end

        shader:register()
    end
end