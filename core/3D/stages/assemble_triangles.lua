local fragment_shader = require("core.3D.stages.fragment_shader")
local frustum_clip    = require("core.3D.geometry.clip_cull_frustum")

local memory_handle = require("core.mem_manager")

local empty = {}

local VERT_1 = {}
local VERT_2 = {}
local VERT_3 = {}

return function(object,prev,geo,prop,efx,out,BUS)
    local frustum_handle = frustum_clip.init(BUS)
    local mem_manager = memory_handle.get(BUS)

    local on = out.n
    local out_tris = out.tris

    local shader = efx.fs
    local geometry_shader = efx.gs

    local tris = geo.tris
    local uvs = geo.uvs
    local uv_indices = geo.uv_idx

    local normals           = geo.normals
    local normal_indices    = geo.normal_idx
    local triangle_textures = geo.texture_idx
    local pixel_sizes       = geo.pixel_sizes
    local material_indexing = geo.material_indexing

    local nuvs  = next(uvs or empty) and next(uv_indices or empty)
    local nnorm = next(normals or empty) and next(normal_indices or empty)
    local ntexs = next(triangle_textures or empty)
    local npxsz = next(pixel_sizes or empty)

    local pixel_size = object.pixel_size
    local texture = object.texture
    local material = object.material
    local material_textures
    if material then material_textures = material.loaded_textures end
    local z_layer = object.z_layer

    local t_index = 0
    for i=1,#tris,3 do
        t_index = t_index + 1

        local t1_vindex = tris[i]  *6
        local t2_vindex = tris[i+1]*6
        local t3_vindex = tris[i+2]*6

        VERT_1.val,VERT_1.frag,VERT_1[1],VERT_1[2],VERT_1[3],VERT_1[4] = prev[t1_vindex-5],prev[t1_vindex-4],prev[t1_vindex-3],prev[t1_vindex-2],prev[t1_vindex-1],prev[t1_vindex]
        VERT_2.val,VERT_2.frag,VERT_2[1],VERT_2[2],VERT_2[3],VERT_2[4] = prev[t2_vindex-5],prev[t2_vindex-4],prev[t2_vindex-3],prev[t2_vindex-2],prev[t2_vindex-1],prev[t2_vindex]
        VERT_3.val,VERT_3.frag,VERT_3[1],VERT_3[2],VERT_3[3],VERT_3[4] = prev[t3_vindex-5],prev[t3_vindex-4],prev[t3_vindex-3],prev[t3_vindex-2],prev[t3_vindex-1],prev[t3_vindex]
        
        if nuvs then
            local uva = uv_indices[i]  *2
            local uvb = uv_indices[i+1]*2
            local uvc = uv_indices[i+2]*2
            VERT_1[5],VERT_1[6] = uvs[uva-1],uvs[uva]
            VERT_2[5],VERT_2[6] = uvs[uvb-1],uvs[uvb]
            VERT_3[5],VERT_3[6] = uvs[uvc-1],uvs[uvc]
        else
            VERT_1[5],VERT_1[6] = nil,nil
            VERT_2[5],VERT_2[6] = nil,nil
            VERT_3[5],VERT_3[6] = nil,nil
        end
        if nnorm then
            local norma = normal_indices[i]  *3
            local normb = normal_indices[i+1]*3
            local normc = normal_indices[i+2]*3

            local normal_1 = mem_manager.get_table()
            local normal_2 = mem_manager.get_table()
            local normal_3 = mem_manager.get_table()

            normal_1[1],normal_1[2],normal_1[3] = normals[norma-2],normals[norma-1],normals[norma]
            normal_2[1],normal_2[2],normal_2[3] = normals[normb-2],normals[normb-1],normals[normb]
            normal_3[1],normal_3[2],normal_3[3] = normals[normc-2],normals[normc-1],normals[normc]

            VERT_1.norm = normal_1
            VERT_2.norm = normal_2
            VERT_3.norm = normal_3
        else
            VERT_1.norm = nil
            VERT_2.norm = nil
            VERT_3.norm = nil
        end

        local tex = texture
        local pix_size = pixel_size
        if material then
            tex = material_textures[material_indexing[t_index]]
        else
            if ntexs then tex = triangle_textures[t_index] end
            if npxsz then pix_size = pixel_sizes[t_index] end
        end
    
        on = frustum_handle(geometry_shader,object,out_tris,
            VERT_1,VERT_2,VERT_3,
        on,fragment_shader(shader),t_index,tex,pix_size,z_layer)
    end

    out.n = on
end