local object = require("core.object")

local tbl = require("common.table_util")

return {add=function(BUS)

    return function()
        local raw_mesh = plugin.new("c3d:object->raw_mesh")

        function raw_mesh.register_objects()
            local object_registry = c3d.registry.get_object_registry()
            local raw_mesh_object = object_registry:new_entry("raw_mesh")

            raw_mesh_object:set_entry(c3d.registry.entry("make_geometry"),function(this)
                local geometry = {
                    vertices=this.vertice_geo_list,
                    uvs=this.uv_geo_list,
                    texture_idx=this.triangle_textures,
                    tris={},uv_idx={},normals={},normal_idx={},
                }

                local tris = geometry.tris
                local uvs  = geometry.uv_idx

                for t=1,this.tx do
                    local t3 = t*3

                    local tri = this.triangles[t]

                    tris[t3-2] = tri[1]
                    tris[t3-1] = tri[2]
                    tris[t3]   = tri[3]

                    uvs[t3-2] = tri[4]
                    uvs[t3-1] = tri[5]
                    uvs[t3]   = tri[6]
                end

                return {geometry=geometry}
            end)

            raw_mesh_object:set_entry(c3d.registry.entry("add_triangle"),function(this,vertices,uvs,texture)
                local verts = this.vertices
                local uvcor = this.uvs
                local vglis = this.vertice_geo_list
                local uglis = this.uv_geo_list

                local v1,v2,v3    = vertices[1],vertices[2],vertices[3]
                local uv1,uv2,uv3 = uvs[1],uvs[2],uvs[3]

                local x1,y1,z1 = v1[1],v1[2],v1[3]
                local x2,y2,z2 = v2[1],v2[2],v2[3]
                local x3,y3,z3 = v3[1],v3[2],v3[3]

                if not verts[x3][y3][z3] then
                    local n = this.vx + 1
                    verts[x3][y3][z3] = n
                    
                    local n3 = n*3
                    vglis[n3-2] = x3
                    vglis[n3-1] = y3
                    vglis[n3]   = z3

                    this.vx = n
                end
                if not verts[x1][y1][z1] then
                    local n = this.vx + 1
                    verts[x1][y1][z1] = n

                    local n3 = n*3
                    vglis[n3-2] = x1
                    vglis[n3-1] = y1
                    vglis[n3]   = z1

                    this.vx = n
                end
                if not verts[x2][y2][z2] then
                    local n = this.vx + 1
                    verts[x2][y2][z2] = n
                    
                    local n3 = n*3
                    vglis[n3-2] = x2
                    vglis[n3-1] = y2
                    vglis[n3]   = z2

                    this.vx = n
                end

                local u1,v1 = uv1[1],uv1[2]
                local u2,v2 = uv2[1],uv2[2]
                local u3,v3 = uv3[1],uv3[2]
                if not uvcor[u3][v3] then
                    local n = this.ux + 1
                    uvcor[u3][v3] = n

                    local n2 = n*2
                    uglis[n2-1] = u3
                    uglis[n2]   = v3

                    this.ux = n
                end
                if not uvcor[u1][v1] then
                    local n = this.ux + 1
                    uvcor[u1][v1] = n
                    
                    local n2 = n*2
                    uglis[n2-1] = u1
                    uglis[n2]   = v1

                    this.ux = n
                end
                if not uvcor[u2][v2] then
                    local n = this.ux + 1
                    uvcor[u2][v2] = n
                    
                    local n2 = n*2
                    uglis[n2-1] = u2
                    uglis[n2]   = v2

                    this.ux = n
                end

                this.tx = this.tx + 1

                this.triangles[this.tx] = {
                    verts[x1][y1][z1],
                    verts[x2][y2][z2],
                    verts[x3][y3][z3],

                    uvcor[u1][v1],
                    uvcor[u2][v2],
                    uvcor[u3][v3]
                }

                this.triangle_textures[this.tx] = texture

                return this
            end)

            raw_mesh_object:constructor(function()
                local obj = {
                    vertices=tbl.createNDarray(2),
                    vertice_geo_list={},
                    uv_geo_list={},
                    triangle_textures={},
                    uvs=tbl.createNDarray(1),
                    triangles={},
                    vx=0,ux=0,tx=0
                }
        
                return obj
            end)
        end

        raw_mesh:register()
    end
end}