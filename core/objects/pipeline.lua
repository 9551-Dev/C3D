local utils = require("common.generic")

return {add=function(BUS)

    return function()
        local pipeline = plugin.new("c3d:object->pipeline")

        function pipeline.register_objects()
            local object_registry = c3d.registry.get_object_registry()
            local pipeline_object = object_registry:new_entry("pipeline")

            pipeline_object:set_entry(c3d.registry.entry("render"),function(this,model,w,h,cam_position,cam_rotation,cam_transform,matrix_perspective,pixel_draw)
                local cam_position,cam_rotation,cam_transform,matrix_perspective = cam_position,cam_rotation,cam_transform,matrix_perspective

                local geometry          = model.geometry
                local triangles_indices = geometry.tris
                local vertices          = geometry.vertices
                local triangle_count    = #triangles_indices

                -- model render data
                local properties      = model.properties
                local matrix_scale    = properties.scale_mat
                local matrix_rotation = properties.rotation_mat
                local matrix_position = properties.pos_mat

                for i=1,triangle_count,3 do
                    -- grab render data
                    local vertex_a_index = triangles_indices[i]  *3
                    local vertex_b_index = triangles_indices[i+1]*3
                    local vertex_c_index = triangles_indices[i+2]*3

                    local vertex_a_x,vertex_a_y,vertex_a_z,vertex_a_w = vertices[vertex_a_index-2],vertices[vertex_a_index-1],vertices[vertex_a_index],1
                    local vertex_b_x,vertex_b_y,vertex_b_z,vertex_b_w = vertices[vertex_b_index-2],vertices[vertex_b_index-1],vertices[vertex_b_index],1
                    local vertex_c_x,vertex_c_y,vertex_c_z,vertex_c_w = vertices[vertex_c_index-2],vertices[vertex_c_index-1],vertices[vertex_c_index],1

                    -- transform_A
                        --scale
                    vertex_a_x,vertex_a_y,vertex_a_z,vertex_a_w =
                        vertex_a_x*matrix_scale[1]+vertex_a_y*matrix_scale[5]+vertex_a_z*matrix_scale[9] +vertex_a_w*matrix_scale[13],
                        vertex_a_x*matrix_scale[2]+vertex_a_y*matrix_scale[6]+vertex_a_z*matrix_scale[10]+vertex_a_w*matrix_scale[14],
                        vertex_a_x*matrix_scale[3]+vertex_a_y*matrix_scale[7]+vertex_a_z*matrix_scale[11]+vertex_a_w*matrix_scale[15],
                        vertex_a_x*matrix_scale[4]+vertex_a_y*matrix_scale[8]+vertex_a_z*matrix_scale[12]+vertex_a_w*matrix_scale[16]
                        --rotation
                    vertex_a_x,vertex_a_y,vertex_a_z,vertex_a_w =
                        vertex_a_x*matrix_rotation[1]+vertex_a_y*matrix_rotation[5]+vertex_a_z*matrix_rotation[9] +vertex_a_w*matrix_rotation[13],
                        vertex_a_x*matrix_rotation[2]+vertex_a_y*matrix_rotation[6]+vertex_a_z*matrix_rotation[10]+vertex_a_w*matrix_rotation[14],
                        vertex_a_x*matrix_rotation[3]+vertex_a_y*matrix_rotation[7]+vertex_a_z*matrix_rotation[11]+vertex_a_w*matrix_rotation[15],
                        vertex_a_x*matrix_rotation[4]+vertex_a_y*matrix_rotation[8]+vertex_a_z*matrix_rotation[12]+vertex_a_w*matrix_rotation[16]
                        --world position
                    vertex_a_x,vertex_a_y,vertex_a_z,vertex_a_w =
                        vertex_a_x*matrix_position[1]+vertex_a_y*matrix_position[5]+vertex_a_z*matrix_position[9] +vertex_a_w*matrix_position[13],
                        vertex_a_x*matrix_position[2]+vertex_a_y*matrix_position[6]+vertex_a_z*matrix_position[10]+vertex_a_w*matrix_position[14],
                        vertex_a_x*matrix_position[3]+vertex_a_y*matrix_position[7]+vertex_a_z*matrix_position[11]+vertex_a_w*matrix_position[15],
                        vertex_a_x*matrix_position[4]+vertex_a_y*matrix_position[8]+vertex_a_z*matrix_position[12]+vertex_a_w*matrix_position[16]

                    -- transform_B
                        --scale
                    vertex_b_x,vertex_b_y,vertex_b_z,vertex_b_w = 
                        vertex_b_x*matrix_scale[1]+vertex_b_y*matrix_scale[5]+vertex_b_z*matrix_scale[9] +vertex_b_w*matrix_scale[13],
                        vertex_b_x*matrix_scale[2]+vertex_b_y*matrix_scale[6]+vertex_b_z*matrix_scale[10]+vertex_b_w*matrix_scale[14],
                        vertex_b_x*matrix_scale[3]+vertex_b_y*matrix_scale[7]+vertex_b_z*matrix_scale[11]+vertex_b_w*matrix_scale[15],
                        vertex_b_x*matrix_scale[4]+vertex_b_y*matrix_scale[8]+vertex_b_z*matrix_scale[12]+vertex_b_w*matrix_scale[16]
                        --rotation
                    vertex_b_x,vertex_b_y,vertex_b_z,vertex_b_w = 
                        vertex_b_x*matrix_rotation[1]+vertex_b_y*matrix_rotation[5]+vertex_b_z*matrix_rotation[9] +vertex_b_w*matrix_rotation[13],
                        vertex_b_x*matrix_rotation[2]+vertex_b_y*matrix_rotation[6]+vertex_b_z*matrix_rotation[10]+vertex_b_w*matrix_rotation[14],
                        vertex_b_x*matrix_rotation[3]+vertex_b_y*matrix_rotation[7]+vertex_b_z*matrix_rotation[11]+vertex_b_w*matrix_rotation[15],
                        vertex_b_x*matrix_rotation[4]+vertex_b_y*matrix_rotation[8]+vertex_b_z*matrix_rotation[12]+vertex_b_w*matrix_rotation[16]
                        --world position
                    vertex_b_x,vertex_b_y,vertex_b_z,vertex_b_w = 
                        vertex_b_x*matrix_position[1]+vertex_b_y*matrix_position[5]+vertex_b_z*matrix_position[9] +vertex_b_w*matrix_position[13],
                        vertex_b_x*matrix_position[2]+vertex_b_y*matrix_position[6]+vertex_b_z*matrix_position[10]+vertex_b_w*matrix_position[14],
                        vertex_b_x*matrix_position[3]+vertex_b_y*matrix_position[7]+vertex_b_z*matrix_position[11]+vertex_b_w*matrix_position[15],
                        vertex_b_x*matrix_position[4]+vertex_b_y*matrix_position[8]+vertex_b_z*matrix_position[12]+vertex_b_w*matrix_position[16]

                    -- transform_C
                        --scale
                    vertex_c_x,vertex_c_y,vertex_c_z,vertex_c_w =
                        vertex_c_x*matrix_scale[1]+vertex_c_y*matrix_scale[5]+vertex_c_z*matrix_scale[9] +vertex_c_w*matrix_scale[13],
                        vertex_c_x*matrix_scale[2]+vertex_c_y*matrix_scale[6]+vertex_c_z*matrix_scale[10]+vertex_c_w*matrix_scale[14],
                        vertex_c_x*matrix_scale[3]+vertex_c_y*matrix_scale[7]+vertex_c_z*matrix_scale[11]+vertex_c_w*matrix_scale[15],
                        vertex_c_x*matrix_scale[4]+vertex_c_y*matrix_scale[8]+vertex_c_z*matrix_scale[12]+vertex_c_w*matrix_scale[16]
                        --rotation
                    vertex_c_x,vertex_c_y,vertex_c_z,vertex_c_w =
                        vertex_c_x*matrix_rotation[1]+vertex_c_y*matrix_rotation[5]+vertex_c_z*matrix_rotation[9] +vertex_c_w*matrix_rotation[13],
                        vertex_c_x*matrix_rotation[2]+vertex_c_y*matrix_rotation[6]+vertex_c_z*matrix_rotation[10]+vertex_c_w*matrix_rotation[14],
                        vertex_c_x*matrix_rotation[3]+vertex_c_y*matrix_rotation[7]+vertex_c_z*matrix_rotation[11]+vertex_c_w*matrix_rotation[15],
                        vertex_c_x*matrix_rotation[4]+vertex_c_y*matrix_rotation[8]+vertex_c_z*matrix_rotation[12]+vertex_c_w*matrix_rotation[16]
                        --world position
                    vertex_c_x,vertex_c_y,vertex_c_z,vertex_c_w =
                        vertex_c_x*matrix_position[1]+vertex_c_y*matrix_position[5]+vertex_c_z*matrix_position[9] +vertex_c_w*matrix_position[13],
                        vertex_c_x*matrix_position[2]+vertex_c_y*matrix_position[6]+vertex_c_z*matrix_position[10]+vertex_c_w*matrix_position[14],
                        vertex_c_x*matrix_position[3]+vertex_c_y*matrix_position[7]+vertex_c_z*matrix_position[11]+vertex_c_w*matrix_position[15],
                        vertex_c_x*matrix_position[4]+vertex_c_y*matrix_position[8]+vertex_c_z*matrix_position[12]+vertex_c_w*matrix_position[16]
                    
                        --camera transform
                    if cam_transform then
                        --custom camera transform
                            -- A
                        vertex_a_x,vertex_a_y,vertex_a_z,vertex_a_w =
                            vertex_a_x*cam_transform[1]+vertex_a_y*cam_transform[5]+vertex_a_z*cam_transform[9] +vertex_a_w*cam_transform[13],
                            vertex_a_x*cam_transform[2]+vertex_a_y*cam_transform[6]+vertex_a_z*cam_transform[10]+vertex_a_w*cam_transform[14],
                            vertex_a_x*cam_transform[3]+vertex_a_y*cam_transform[7]+vertex_a_z*cam_transform[11]+vertex_a_w*cam_transform[15],
                            vertex_a_x*cam_transform[4]+vertex_a_y*cam_transform[8]+vertex_a_z*cam_transform[12]+vertex_a_w*cam_transform[16]
                            -- B
                        vertex_b_x,vertex_b_y,vertex_b_z,vertex_b_w = 
                            vertex_b_x*cam_transform[1]+vertex_b_y*cam_transform[5]+vertex_b_z*cam_transform[9] +vertex_b_w*cam_transform[13],
                            vertex_b_x*cam_transform[2]+vertex_b_y*cam_transform[6]+vertex_b_z*cam_transform[10]+vertex_b_w*cam_transform[14],
                            vertex_b_x*cam_transform[3]+vertex_b_y*cam_transform[7]+vertex_b_z*cam_transform[11]+vertex_b_w*cam_transform[15],
                            vertex_b_x*cam_transform[4]+vertex_b_y*cam_transform[8]+vertex_b_z*cam_transform[12]+vertex_b_w*cam_transform[16]
                            -- C
                        vertex_c_x,vertex_c_y,vertex_c_z,vertex_c_w =
                            vertex_c_x*cam_transform[1]+vertex_c_y*cam_transform[5]+vertex_c_z*cam_transform[9] +vertex_c_w*cam_transform[13],
                            vertex_c_x*cam_transform[2]+vertex_c_y*cam_transform[6]+vertex_c_z*cam_transform[10]+vertex_c_w*cam_transform[14],
                            vertex_c_x*cam_transform[3]+vertex_c_y*cam_transform[7]+vertex_c_z*cam_transform[11]+vertex_c_w*cam_transform[15],
                            vertex_c_x*cam_transform[4]+vertex_c_y*cam_transform[8]+vertex_c_z*cam_transform[12]+vertex_c_w*cam_transform[16]
                    else
                        --camera position
                            -- A
                        vertex_a_x,vertex_a_y,vertex_a_z,vertex_a_w =
                            vertex_a_x*cam_position[1]+vertex_a_y*cam_position[5]+vertex_a_z*cam_position[9] +vertex_a_w*cam_position[13],
                            vertex_a_x*cam_position[2]+vertex_a_y*cam_position[6]+vertex_a_z*cam_position[10]+vertex_a_w*cam_position[14],
                            vertex_a_x*cam_position[3]+vertex_a_y*cam_position[7]+vertex_a_z*cam_position[11]+vertex_a_w*cam_position[15],
                            vertex_a_x*cam_position[4]+vertex_a_y*cam_position[8]+vertex_a_z*cam_position[12]+vertex_a_w*cam_position[16]
                            -- B
                        vertex_b_x,vertex_b_y,vertex_b_z,vertex_b_w = 
                            vertex_b_x*cam_position[1]+vertex_b_y*cam_position[5]+vertex_b_z*cam_position[9] +vertex_b_w*cam_position[13],
                            vertex_b_x*cam_position[2]+vertex_b_y*cam_position[6]+vertex_b_z*cam_position[10]+vertex_b_w*cam_position[14],
                            vertex_b_x*cam_position[3]+vertex_b_y*cam_position[7]+vertex_b_z*cam_position[11]+vertex_b_w*cam_position[15],
                            vertex_b_x*cam_position[4]+vertex_b_y*cam_position[8]+vertex_b_z*cam_position[12]+vertex_b_w*cam_position[16]
                            -- C
                        vertex_c_x,vertex_c_y,vertex_c_z,vertex_c_w =
                            vertex_c_x*cam_position[1]+vertex_c_y*cam_position[5]+vertex_c_z*cam_position[9] +vertex_c_w*cam_position[13],
                            vertex_c_x*cam_position[2]+vertex_c_y*cam_position[6]+vertex_c_z*cam_position[10]+vertex_c_w*cam_position[14],
                            vertex_c_x*cam_position[3]+vertex_c_y*cam_position[7]+vertex_c_z*cam_position[11]+vertex_c_w*cam_position[15],
                            vertex_c_x*cam_position[4]+vertex_c_y*cam_position[8]+vertex_c_z*cam_position[12]+vertex_c_w*cam_position[16]

                        --camera rotation
                            -- A
                        vertex_a_x,vertex_a_y,vertex_a_z,vertex_a_w =
                            vertex_a_x*cam_rotation[1]+vertex_a_y*cam_rotation[5]+vertex_a_z*cam_rotation[9] +vertex_a_w*cam_rotation[13],
                            vertex_a_x*cam_rotation[2]+vertex_a_y*cam_rotation[6]+vertex_a_z*cam_rotation[10]+vertex_a_w*cam_rotation[14],
                            vertex_a_x*cam_rotation[3]+vertex_a_y*cam_rotation[7]+vertex_a_z*cam_rotation[11]+vertex_a_w*cam_rotation[15],
                            vertex_a_x*cam_rotation[4]+vertex_a_y*cam_rotation[8]+vertex_a_z*cam_rotation[12]+vertex_a_w*cam_rotation[16]
                            -- B
                        vertex_b_x,vertex_b_y,vertex_b_z,vertex_b_w = 
                            vertex_b_x*cam_rotation[1]+vertex_b_y*cam_rotation[5]+vertex_b_z*cam_rotation[9] +vertex_b_w*cam_rotation[13],
                            vertex_b_x*cam_rotation[2]+vertex_b_y*cam_rotation[6]+vertex_b_z*cam_rotation[10]+vertex_b_w*cam_rotation[14],
                            vertex_b_x*cam_rotation[3]+vertex_b_y*cam_rotation[7]+vertex_b_z*cam_rotation[11]+vertex_b_w*cam_rotation[15],
                            vertex_b_x*cam_rotation[4]+vertex_b_y*cam_rotation[8]+vertex_b_z*cam_rotation[12]+vertex_b_w*cam_rotation[16]
                            -- C
                        vertex_c_x,vertex_c_y,vertex_c_z,vertex_c_w =
                            vertex_c_x*cam_rotation[1]+vertex_c_y*cam_rotation[5]+vertex_c_z*cam_rotation[9] +vertex_c_w*cam_rotation[13],
                            vertex_c_x*cam_rotation[2]+vertex_c_y*cam_rotation[6]+vertex_c_z*cam_rotation[10]+vertex_c_w*cam_rotation[14],
                            vertex_c_x*cam_rotation[3]+vertex_c_y*cam_rotation[7]+vertex_c_z*cam_rotation[11]+vertex_c_w*cam_rotation[15],
                            vertex_c_x*cam_rotation[4]+vertex_c_y*cam_rotation[8]+vertex_c_z*cam_rotation[12]+vertex_c_w*cam_rotation[16]
                    end

                    --perspective
                        -- A
                    vertex_a_x,vertex_a_y,vertex_a_z,vertex_a_w =
                        vertex_a_x*matrix_perspective[1]+vertex_a_y*matrix_perspective[5]+vertex_a_z*matrix_perspective[9] +vertex_a_w*matrix_perspective[13],
                        vertex_a_x*matrix_perspective[2]+vertex_a_y*matrix_perspective[6]+vertex_a_z*matrix_perspective[10]+vertex_a_w*matrix_perspective[14],
                        vertex_a_x*matrix_perspective[3]+vertex_a_y*matrix_perspective[7]+vertex_a_z*matrix_perspective[11]+vertex_a_w*matrix_perspective[15],
                        vertex_a_x*matrix_perspective[4]+vertex_a_y*matrix_perspective[8]+vertex_a_z*matrix_perspective[12]+vertex_a_w*matrix_perspective[16]
                        -- B
                    vertex_b_x,vertex_b_y,vertex_b_z,vertex_b_w = 
                        vertex_b_x*matrix_perspective[1]+vertex_b_y*matrix_perspective[5]+vertex_b_z*matrix_perspective[9] +vertex_b_w*matrix_perspective[13],
                        vertex_b_x*matrix_perspective[2]+vertex_b_y*matrix_perspective[6]+vertex_b_z*matrix_perspective[10]+vertex_b_w*matrix_perspective[14],
                        vertex_b_x*matrix_perspective[3]+vertex_b_y*matrix_perspective[7]+vertex_b_z*matrix_perspective[11]+vertex_b_w*matrix_perspective[15],
                        vertex_b_x*matrix_perspective[4]+vertex_b_y*matrix_perspective[8]+vertex_b_z*matrix_perspective[12]+vertex_b_w*matrix_perspective[16]
                        -- C
                    vertex_c_x,vertex_c_y,vertex_c_z,vertex_c_w =
                        vertex_c_x*matrix_perspective[1]+vertex_c_y*matrix_perspective[5]+vertex_c_z*matrix_perspective[9] +vertex_c_w*matrix_perspective[13],
                        vertex_c_x*matrix_perspective[2]+vertex_c_y*matrix_perspective[6]+vertex_c_z*matrix_perspective[10]+vertex_c_w*matrix_perspective[14],
                        vertex_c_x*matrix_perspective[3]+vertex_c_y*matrix_perspective[7]+vertex_c_z*matrix_perspective[11]+vertex_c_w*matrix_perspective[15],
                        vertex_c_x*matrix_perspective[4]+vertex_c_y*matrix_perspective[8]+vertex_c_z*matrix_perspective[12]+vertex_c_w*matrix_perspective[16]

                    --transformation into NDC space
                        -- A
                    local vertex_a_w_inverse = 1/vertex_a_w
                    vertex_a_x = ( vertex_a_x*vertex_a_w_inverse+1)*w/2
                    vertex_a_y = (-vertex_a_y*vertex_a_w_inverse+1)*h/2
                    vertex_a_z = vertex_a_w_inverse
                    vertex_a_w = vertex_a_w
                        -- B
                    local vertex_b_w_inverse = 1/vertex_b_w
                    vertex_b_x = ( vertex_b_x*vertex_b_w_inverse+1)*w/2
                    vertex_b_y = (-vertex_b_y*vertex_b_w_inverse+1)*h/2
                    vertex_b_z = vertex_b_w_inverse
                    vertex_b_w = vertex_b_w
                        -- C
                    local vertex_c_w_inverse = 1/vertex_c_w
                    vertex_c_x = ( vertex_c_x*vertex_c_w_inverse+1)*w/2
                    vertex_c_y = (-vertex_c_y*vertex_c_w_inverse+1)*h/2
                    vertex_c_z = vertex_c_w_inverse
                    vertex_c_w = vertex_c_w

                    -- draw

                        -- height sort
                    if vertex_a_y > vertex_c_y then
                        vertex_a_x,vertex_c_x = vertex_c_x,vertex_a_x
                        vertex_a_y,vertex_c_y = vertex_c_y,vertex_a_y
                        vertex_a_z,vertex_c_z = vertex_c_z,vertex_a_z
                        vertex_a_w,vertex_c_w = vertex_c_w,vertex_a_w
                    end
                    if vertex_a_y > vertex_b_y then
                        vertex_a_x,vertex_b_x = vertex_b_x,vertex_a_x
                        vertex_a_y,vertex_b_y = vertex_b_y,vertex_a_y
                        vertex_a_z,vertex_b_z = vertex_b_z,vertex_a_z
                        vertex_a_w,vertex_b_w = vertex_b_w,vertex_a_w
                    end
                    if vertex_b_y > vertex_c_y then
                        vertex_c_x,vertex_b_x = vertex_b_x,vertex_c_x
                        vertex_c_y,vertex_b_y = vertex_b_y,vertex_c_y
                        vertex_c_z,vertex_b_z = vertex_b_z,vertex_c_z
                        vertex_c_w,vertex_b_w = vertex_b_w,vertex_c_w
                    end

                    -- split point interpolation
                    local split_alpha   = (vertex_b_y-vertex_a_y)/(vertex_c_y-vertex_a_y)
                    local right_point_x = (1-split_alpha)*vertex_a_x + split_alpha*vertex_c_x
                    local right_point_y = (1-split_alpha)*vertex_a_y + split_alpha*vertex_c_y
                    local right_point_z = (1-split_alpha)*vertex_a_z + split_alpha*vertex_c_z
                    local right_point_w = (1-split_alpha)*vertex_a_w + split_alpha*vertex_c_w

                    local left_point_x = vertex_b_x
                    local left_point_y = vertex_b_y
                    local left_point_z = vertex_b_z
                    local left_point_w = right_point_w

                    -- left-right point sort
                    if left_point_x > right_point_x then
                        left_point_x,right_point_x = right_point_x,left_point_x
                        left_point_y,right_point_y = right_point_y,left_point_y
                        left_point_z,right_point_z = right_point_z,left_point_z
                        left_point_w,right_point_w = right_point_w,left_point_w
                    end

                    local delta_left_top  = 1/((left_point_y -vertex_a_y)/(left_point_x -vertex_a_x))
                    local delta_right_top = 1/((right_point_y-vertex_a_y)/(right_point_x-vertex_a_x))

                    local delta_left_bottom  = 1/((left_point_y -vertex_c_y)/(left_point_x -vertex_c_x))
                    local delta_right_bottom = 1/((right_point_y-vertex_c_y)/(right_point_x-vertex_c_x))

                    -- flat bottom
                    local offset_top    = math.floor(vertex_a_y+0.5) + 0.5 - vertex_a_y
                    local offset_bottom = math.floor(vertex_b_y+0.5) + 0.5 - left_point_y

                    local x_left,x_right = vertex_a_x + delta_left_top * offset_top,vertex_a_x + delta_right_top * offset_top

                    if delta_left_top then
                        for y=math.floor(vertex_a_y+0.5),math.floor(vertex_b_y+0.5)-1 do

                            for x=math.ceil(x_left-0.5),math.ceil(x_right-0.5)-1 do
                                local div    = ((left_point_y -right_point_y) *(vertex_a_x-right_point_x) + (right_point_x-left_point_x) *(vertex_a_y-right_point_y))
                                local bary_a = ((left_point_y -right_point_y) *(x         -right_point_x) + (right_point_x-left_point_x) *(y-right_point_y)) / div
                                local bary_b = ((right_point_y-vertex_a_y    )*(x         -right_point_x) + (vertex_a_x   -right_point_x)*(y-right_point_y)) / div
                                local bary_c = 1-bary_a-bary_b

                                local depth = vertex_a_z*bary_a+left_point_z*bary_b+right_point_z*bary_c

                                pixel_draw(x,y,depth,(i+2)/3)
                            end
                        
                            x_left,x_right = x_left+delta_left_top,x_right+delta_right_top
                        end
                    end


                    -- flat top
                    x_left,x_right = left_point_x + delta_left_bottom * offset_bottom,right_point_x + delta_right_bottom * offset_bottom
                    if delta_left_bottom then
                        for y=math.floor(vertex_b_y+0.5),math.ceil(vertex_c_y-0.5) do

                            for x=math.ceil(x_left-0.5),math.ceil(x_right-0.5)-1 do
                                local div    = ((right_point_y-vertex_c_y)  *(left_point_x-vertex_c_x) + (vertex_c_x  -right_point_x)*(left_point_y-vertex_c_y))
                                local bary_a = ((right_point_y-vertex_c_y)  *(x           -vertex_c_x) + (vertex_c_x  -right_point_x)*(y-vertex_c_y)) / div
                                local bary_b = ((vertex_c_y   -left_point_y)*(x           -vertex_c_x) + (left_point_x-vertex_c_x)   *(y-vertex_c_y)) / div
                                local bary_c = 1-bary_a-bary_b

                                local depth = left_point_z*bary_a+right_point_z*bary_b+vertex_c_z*bary_c

                                pixel_draw(x,y,depth,(i+2)/3)
                            end


                            x_left,x_right = x_left+delta_left_bottom,x_right+delta_right_bottom
                        end
                    end
                end
            end)

            pipeline_object:constructor(function(id_override)
                local id = id_override or utils.uuid4()
                local object = {id=id}

                BUS.pipe.pipelines[id] = object

                return object
            end)
        end

        pipeline:register()
    end
end}
