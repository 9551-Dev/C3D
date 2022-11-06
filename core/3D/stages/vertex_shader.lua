local matmul = require("core.3D.math.matmul")

return function(object,prev,geo,prop,efx,out,BUS,object_texture,camera)
    local transformed_vertices = {}
    local per = BUS.perspective.matrix

    local scale = prop.scale_mat
    local rot   = prop.rotation_mat
    local pos   = prop.pos_mat

    local shader = efx.vs

    local vertice_index = 0

    local cam_transform = camera.transform
    local cam_position  = camera.position
    local cam_rotation  = camera.rotation

    for i=1,#prev,3 do
        vertice_index = vertice_index + 1

        local final_vertice

        if shader then
                final_vertice = shader(prev[i],prev[i+1],prev[i+2],1,prop,scale,rot,pos,per,cam_transform,cam_position,cam_rotation)
        else
            local sc1,sc2,sc3,sc4 = matmul(prev[i],prev[i+1],prev[i+2],1,scale)
            local rx1,ry2,ry3,ry4 = matmul(sc1,sc2,sc3,sc4,rot)
            local tl1,tl2,tl3,tl4 = matmul(rx1,ry2,ry3,ry4,pos)
            local ct1,ct2,ct3,ct4
            if cam_transform then
                ct1,ct2,ct3,ct4 = matmul(tl1,tl2,tl3,tl4,cam_transform)
            else
                local cp1,cp2,cp3,cp4 = matmul(tl1,tl2,tl3,tl4,cam_position)
                ct1,ct2,ct3,ct4 = matmul(cp1,cp2,cp3,cp4,cam_rotation)
            end

            final_vertice = {matmul(ct1,ct2,ct3,ct4,per)}
        end

        transformed_vertices[vertice_index] = final_vertice
    end

    return transformed_vertices
end