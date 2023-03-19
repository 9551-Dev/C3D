local utils = require("common.generic")

return {add=function(BUS)

    return function()
        local pipeline = plugin.new("c3d:object->pipeline")

        function pipeline.register_objects()
            local object_registry = c3d.registry.get_object_registry()
            local pipeline_object = object_registry:new_entry("pipeline")

            pipeline_object:set_entry(c3d.registry.entry("render"),function(this,model,cam_position,cam_rotation,cam_transform,pixel_draw)
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
                    vertex_a_x = vertex_a_x*matrix_scale[1]+vertex_a_y*matrix_scale[5]+vertex_a_z*matrix_scale[9] +vertex_a_w*matrix_scale[13]
                    vertex_a_y = vertex_a_x*matrix_scale[2]+vertex_a_y*matrix_scale[6]+vertex_a_z*matrix_scale[10]+vertex_a_w*matrix_scale[14]
                    vertex_a_z = vertex_a_x*matrix_scale[3]+vertex_a_y*matrix_scale[7]+vertex_a_z*matrix_scale[11]+vertex_a_w*matrix_scale[15]
                    vertex_a_w = vertex_a_x*matrix_scale[4]+vertex_a_y*matrix_scale[8]+vertex_a_z*matrix_scale[12]+vertex_a_w*matrix_scale[16]
                        --rotation
                    vertex_a_x = vertex_a_x*matrix_rotation[1]+vertex_a_y*matrix_rotation[5]+vertex_a_z*matrix_rotation[9] +vertex_a_w*matrix_rotation[13]
                    vertex_a_y = vertex_a_x*matrix_rotation[2]+vertex_a_y*matrix_rotation[6]+vertex_a_z*matrix_rotation[10]+vertex_a_w*matrix_rotation[14]
                    vertex_a_z = vertex_a_x*matrix_rotation[3]+vertex_a_y*matrix_rotation[7]+vertex_a_z*matrix_rotation[11]+vertex_a_w*matrix_rotation[15]
                    vertex_a_w = vertex_a_x*matrix_rotation[4]+vertex_a_y*matrix_rotation[8]+vertex_a_z*matrix_rotation[12]+vertex_a_w*matrix_rotation[16]
                        --world position
                    vertex_a_x = vertex_a_x*matrix_position[1]+vertex_a_y*matrix_position[5]+vertex_a_z*matrix_position[9] +vertex_a_w*matrix_position[13]
                    vertex_a_y = vertex_a_x*matrix_position[2]+vertex_a_y*matrix_position[6]+vertex_a_z*matrix_position[10]+vertex_a_w*matrix_position[14]
                    vertex_a_z = vertex_a_x*matrix_position[3]+vertex_a_y*matrix_position[7]+vertex_a_z*matrix_position[11]+vertex_a_w*matrix_position[15]
                    vertex_a_w = vertex_a_x*matrix_position[4]+vertex_a_y*matrix_position[8]+vertex_a_z*matrix_position[12]+vertex_a_w*matrix_position[16]

                    -- transform_B
                        --scale
                    vertex_b_x = vertex_b_x*matrix_scale[1]+vertex_b_y*matrix_scale[5]+vertex_b_z*matrix_scale[9] +vertex_b_w*matrix_scale[13]
                    vertex_b_y = vertex_b_x*matrix_scale[2]+vertex_b_y*matrix_scale[6]+vertex_b_z*matrix_scale[10]+vertex_b_w*matrix_scale[14]
                    vertex_b_z = vertex_b_x*matrix_scale[3]+vertex_b_y*matrix_scale[7]+vertex_b_z*matrix_scale[11]+vertex_b_w*matrix_scale[15]
                    vertex_b_w = vertex_b_x*matrix_scale[4]+vertex_b_y*matrix_scale[8]+vertex_b_z*matrix_scale[12]+vertex_b_w*matrix_scale[16]
                        --rotation
                    vertex_b_x = vertex_b_x*matrix_rotation[1]+vertex_b_y*matrix_rotation[5]+vertex_b_z*matrix_rotation[9] +vertex_b_w*matrix_rotation[13]
                    vertex_b_y = vertex_b_x*matrix_rotation[2]+vertex_b_y*matrix_rotation[6]+vertex_b_z*matrix_rotation[10]+vertex_b_w*matrix_rotation[14]
                    vertex_b_z = vertex_b_x*matrix_rotation[3]+vertex_b_y*matrix_rotation[7]+vertex_b_z*matrix_rotation[11]+vertex_b_w*matrix_rotation[15]
                    vertex_b_w = vertex_b_x*matrix_rotation[4]+vertex_b_y*matrix_rotation[8]+vertex_b_z*matrix_rotation[12]+vertex_b_w*matrix_rotation[16]
                        --world position
                    vertex_b_x = vertex_b_x*matrix_position[1]+vertex_b_y*matrix_position[5]+vertex_b_z*matrix_position[9] +vertex_b_w*matrix_position[13]
                    vertex_b_y = vertex_b_x*matrix_position[2]+vertex_b_y*matrix_position[6]+vertex_b_z*matrix_position[10]+vertex_b_w*matrix_position[14]
                    vertex_b_z = vertex_b_x*matrix_position[3]+vertex_b_y*matrix_position[7]+vertex_b_z*matrix_position[11]+vertex_b_w*matrix_position[15]
                    vertex_b_w = vertex_b_x*matrix_position[4]+vertex_b_y*matrix_position[8]+vertex_b_z*matrix_position[12]+vertex_b_w*matrix_position[16]

                    -- transform_C
                        --scale
                    vertex_c_x = vertex_c_x*matrix_scale[1]+vertex_c_y*matrix_scale[5]+vertex_c_z*matrix_scale[9] +vertex_c_w*matrix_scale[13]
                    vertex_c_y = vertex_c_x*matrix_scale[2]+vertex_c_y*matrix_scale[6]+vertex_c_z*matrix_scale[10]+vertex_c_w*matrix_scale[14]
                    vertex_c_z = vertex_c_x*matrix_scale[3]+vertex_c_y*matrix_scale[7]+vertex_c_z*matrix_scale[11]+vertex_c_w*matrix_scale[15]
                    vertex_c_w = vertex_c_x*matrix_scale[4]+vertex_c_y*matrix_scale[8]+vertex_c_z*matrix_scale[12]+vertex_c_w*matrix_scale[16]
                        --rotation
                    vertex_c_x = vertex_c_x*matrix_rotation[1]+vertex_c_y*matrix_rotation[5]+vertex_c_z*matrix_rotation[9] +vertex_c_w*matrix_rotation[13]
                    vertex_c_y = vertex_c_x*matrix_rotation[2]+vertex_c_y*matrix_rotation[6]+vertex_c_z*matrix_rotation[10]+vertex_c_w*matrix_rotation[14]
                    vertex_c_z = vertex_c_x*matrix_rotation[3]+vertex_c_y*matrix_rotation[7]+vertex_c_z*matrix_rotation[11]+vertex_c_w*matrix_rotation[15]
                    vertex_c_w = vertex_c_x*matrix_rotation[4]+vertex_c_y*matrix_rotation[8]+vertex_c_z*matrix_rotation[12]+vertex_c_w*matrix_rotation[16]
                        --world position
                    vertex_c_x = vertex_c_x*matrix_position[1]+vertex_c_y*matrix_position[5]+vertex_c_z*matrix_position[9] +vertex_c_w*matrix_position[13]
                    vertex_c_y = vertex_c_x*matrix_position[2]+vertex_c_y*matrix_position[6]+vertex_c_z*matrix_position[10]+vertex_c_w*matrix_position[14]
                    vertex_c_z = vertex_c_x*matrix_position[3]+vertex_c_y*matrix_position[7]+vertex_c_z*matrix_position[11]+vertex_c_w*matrix_position[15]
                    vertex_c_w = vertex_c_x*matrix_position[4]+vertex_c_y*matrix_position[8]+vertex_c_z*matrix_position[12]+vertex_c_w*matrix_position[16]
                        --camera transform
                    if cam_transform then
                        --custom camera transform
                            -- A
                        vertex_a_x = vertex_a_x*cam_transform[1]+vertex_a_y*cam_transform[5]+vertex_a_z*cam_transform[9] +vertex_a_w*cam_transform[13]
                        vertex_a_y = vertex_a_x*cam_transform[2]+vertex_a_y*cam_transform[6]+vertex_a_z*cam_transform[10]+vertex_a_w*cam_transform[14]
                        vertex_a_z = vertex_a_x*cam_transform[3]+vertex_a_y*cam_transform[7]+vertex_a_z*cam_transform[11]+vertex_a_w*cam_transform[15]
                        vertex_a_w = vertex_a_x*cam_transform[4]+vertex_a_y*cam_transform[8]+vertex_a_z*cam_transform[12]+vertex_a_w*cam_transform[16]
                            -- B
                        vertex_b_x = vertex_b_x*cam_transform[1]+vertex_b_y*cam_transform[5]+vertex_b_z*cam_transform[9] +vertex_b_w*cam_transform[13]
                        vertex_b_y = vertex_b_x*cam_transform[2]+vertex_b_y*cam_transform[6]+vertex_b_z*cam_transform[10]+vertex_b_w*cam_transform[14]
                        vertex_b_z = vertex_b_x*cam_transform[3]+vertex_b_y*cam_transform[7]+vertex_b_z*cam_transform[11]+vertex_b_w*cam_transform[15]
                        vertex_b_w = vertex_b_x*cam_transform[4]+vertex_b_y*cam_transform[8]+vertex_b_z*cam_transform[12]+vertex_b_w*cam_transform[16]
                            -- C
                        vertex_c_x = vertex_c_x*cam_transform[1]+vertex_c_y*cam_transform[5]+vertex_c_z*cam_transform[9] +vertex_c_w*cam_transform[13]
                        vertex_c_y = vertex_c_x*cam_transform[2]+vertex_c_y*cam_transform[6]+vertex_c_z*cam_transform[10]+vertex_c_w*cam_transform[14]
                        vertex_c_z = vertex_c_x*cam_transform[3]+vertex_c_y*cam_transform[7]+vertex_c_z*cam_transform[11]+vertex_c_w*cam_transform[15]
                        vertex_c_w = vertex_c_x*cam_transform[4]+vertex_c_y*cam_transform[8]+vertex_c_z*cam_transform[12]+vertex_c_w*cam_transform[16]
                    else
                        --camera position
                            -- A
                        vertex_a_x = vertex_a_x*cam_position[1]+vertex_a_y*cam_position[5]+vertex_a_z*cam_position[9] +vertex_a_w*cam_position[13]
                        vertex_a_y = vertex_a_x*cam_position[2]+vertex_a_y*cam_position[6]+vertex_a_z*cam_position[10]+vertex_a_w*cam_position[14]
                        vertex_a_z = vertex_a_x*cam_position[3]+vertex_a_y*cam_position[7]+vertex_a_z*cam_position[11]+vertex_a_w*cam_position[15]
                        vertex_a_w = vertex_a_x*cam_position[4]+vertex_a_y*cam_position[8]+vertex_a_z*cam_position[12]+vertex_a_w*cam_position[16]
                            -- B
                        vertex_b_x = vertex_b_x*cam_position[1]+vertex_b_y*cam_position[5]+vertex_b_z*cam_position[9] +vertex_b_w*cam_position[13]
                        vertex_b_y = vertex_b_x*cam_position[2]+vertex_b_y*cam_position[6]+vertex_b_z*cam_position[10]+vertex_b_w*cam_position[14]
                        vertex_b_z = vertex_b_x*cam_position[3]+vertex_b_y*cam_position[7]+vertex_b_z*cam_position[11]+vertex_b_w*cam_position[15]
                        vertex_b_w = vertex_b_x*cam_position[4]+vertex_b_y*cam_position[8]+vertex_b_z*cam_position[12]+vertex_b_w*cam_position[16]
                            -- C
                        vertex_c_x = vertex_c_x*cam_position[1]+vertex_c_y*cam_position[5]+vertex_c_z*cam_position[9] +vertex_c_w*cam_position[13]
                        vertex_c_y = vertex_c_x*cam_position[2]+vertex_c_y*cam_position[6]+vertex_c_z*cam_position[10]+vertex_c_w*cam_position[14]
                        vertex_c_z = vertex_c_x*cam_position[3]+vertex_c_y*cam_position[7]+vertex_c_z*cam_position[11]+vertex_c_w*cam_position[15]
                        vertex_c_w = vertex_c_x*cam_position[4]+vertex_c_y*cam_position[8]+vertex_c_z*cam_position[12]+vertex_c_w*cam_position[16]

                        --camera rotation
                            -- A
                        vertex_a_x = vertex_a_x*cam_rotation[1]+vertex_a_y*cam_rotation[5]+vertex_a_z*cam_rotation[9] +vertex_a_w*cam_rotation[13]
                        vertex_a_y = vertex_a_x*cam_rotation[2]+vertex_a_y*cam_rotation[6]+vertex_a_z*cam_rotation[10]+vertex_a_w*cam_rotation[14]
                        vertex_a_z = vertex_a_x*cam_rotation[3]+vertex_a_y*cam_rotation[7]+vertex_a_z*cam_rotation[11]+vertex_a_w*cam_rotation[15]
                        vertex_a_w = vertex_a_x*cam_rotation[4]+vertex_a_y*cam_rotation[8]+vertex_a_z*cam_rotation[12]+vertex_a_w*cam_rotation[16]
                            -- B
                        vertex_b_x = vertex_b_x*cam_rotation[1]+vertex_b_y*cam_rotation[5]+vertex_b_z*cam_rotation[9] +vertex_b_w*cam_rotation[13]
                        vertex_b_y = vertex_b_x*cam_rotation[2]+vertex_b_y*cam_rotation[6]+vertex_b_z*cam_rotation[10]+vertex_b_w*cam_rotation[14]
                        vertex_b_z = vertex_b_x*cam_rotation[3]+vertex_b_y*cam_rotation[7]+vertex_b_z*cam_rotation[11]+vertex_b_w*cam_rotation[15]
                        vertex_b_w = vertex_b_x*cam_rotation[4]+vertex_b_y*cam_rotation[8]+vertex_b_z*cam_rotation[12]+vertex_b_w*cam_rotation[16]
                            -- C
                        vertex_c_x = vertex_c_x*cam_rotation[1]+vertex_c_y*cam_rotation[5]+vertex_c_z*cam_rotation[9] +vertex_c_w*cam_rotation[13]
                        vertex_c_y = vertex_c_x*cam_rotation[2]+vertex_c_y*cam_rotation[6]+vertex_c_z*cam_rotation[10]+vertex_c_w*cam_rotation[14]
                        vertex_c_z = vertex_c_x*cam_rotation[3]+vertex_c_y*cam_rotation[7]+vertex_c_z*cam_rotation[11]+vertex_c_w*cam_rotation[15]
                        vertex_c_w = vertex_c_x*cam_rotation[4]+vertex_c_y*cam_rotation[8]+vertex_c_z*cam_rotation[12]+vertex_c_w*cam_rotation[16]
                    end

                    -- draw
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
