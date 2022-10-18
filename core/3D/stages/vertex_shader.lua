local matmul = require("core.3D.math.matmul")

return function(object,prev,geo,prop,efx,out,BUS,object_texture,camera)
    local transformed_vertices = {}
    local per = BUS.persperctive.matrix

    local scale = prop.scale_mat
    local rot   = prop.rotation_mat
    local pos   = prop.pos_mat

    local shader = efx.vs
    local uvs = geo.uvs

    local vertice_index = 0
    for i=1,#prev,3 do
        vertice_index = vertice_index + 1

        local new_vertice = {
            prev[i],prev[i+1],prev[i+2],1,index=vertice_index
        }

        local final_vertice

        if shader then
            final_vertice = shader(new_vertice,prop,scale,rot,pos,camera,per)
        else
            local scaled_vertice     = matmul(new_vertice,scale)
            local rotated_vertice    = matmul(scaled_vertice,rot)
            local translated_vertice = matmul(rotated_vertice,pos)
            local camera_transform   = matmul(matmul(translated_vertice,camera.position),camera.rotation)
            final_vertice            = matmul(camera_transform,per)
        end

        if uvs then
            final_vertice[5] = uvs[vertice_index*2-1] or 0
            final_vertice[6] = uvs[vertice_index*2]   or 0
        else
            final_vertice[5],final_vertice[6] = 0,0
        end

        transformed_vertices[vertice_index] = final_vertice
    end

    return transformed_vertices
end