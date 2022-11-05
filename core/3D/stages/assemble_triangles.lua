local frustum_handle  = require("core.3D.geometry.clip_cull_frustum")
local fragment_shader = require("core.3D.stages.fragment_shader")

local tbl_util = require("common.table_util")

local empty = {}

return function(object,prev,geo,prop,efx,out,BUS)
    local on = out.n
    local out_tris = out.tris

    local shader = efx.fs

    local tris = geo.tris
    local uvs = geo.uvs
    local uv_indices = geo.uv_idx

    local normals           = geo.normals
    local normal_indices    = geo.normal_idx
    local triangle_textures = geo.texture_idx
    local pixel_sizes       = geo.pixel_sizes

    local nuvs  = next(uvs or empty) and next(uv_indices or empty)
    local nnorm = next(normals or empty) and next(normal_indices or empty)
    local ntexs = next(triangle_textures or empty)
    local npxsz = next(pixel_sizes or empty)

    local pixel_size = object.pixel_size
    local texture = object.texture
    local z_layer = object.z_layer

    local t_index = 0
    for i=1,#tris,3 do
        t_index = t_index + 1

        local a = tbl_util.make_vertex_copy(prev[tris[i]])
        local b = tbl_util.make_vertex_copy(prev[tris[i+1]])
        local c = tbl_util.make_vertex_copy(prev[tris[i+2]])

        if nuvs then
            local uva = uv_indices[i]  *2
            local uvb = uv_indices[i+1]*2
            local uvc = uv_indices[i+2]*2
            a[5],a[6] = uvs[uva-1],uvs[uva]
            b[5],b[6] = uvs[uvb-1],uvs[uvb]
            c[5],c[6] = uvs[uvc-1],uvs[uvc]
        end
        if nnorm then
            local norma = normal_indices[i]  *3
            local normb = normal_indices[i+1]*3
            local normc = normal_indices[i+2]*3
            a.norm = {normals[norma-2],normals[norma-1],normals[norma]}
            b.norm = {normals[normb-2],normals[normb-1],normals[normb]}
            c.norm = {normals[normc-2],normals[normc-1],normals[normc]}
        end

        local tex = texture
        local pix_size = pixel_size
        if ntexs then tex = ntexs[t_index] end
        if npxsz then pix_size = npxsz[t_index] end

        on = frustum_handle(object,out_tris,a,b,c,on,fragment_shader(shader),t_index,tex,pix_size,z_layer)
    end

    out.n = on
end