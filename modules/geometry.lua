return function(BUS)

    local s = 0.5

    return function()
        local geometry = plugin:new("c3d:geometry")

        function geometry.register_modules()
            local module_registry = c3d.registry.get_module_registry()
            local geometry_module = module_registry:new_entry("geometry")

            geometry_module:set_entry(c3d.registry.entry("cube_simple"),function(cust_scale)
                local s = cust_scale or s
                return BUS.object.generic_shape.new{
                    geometry={
                        vertices={
                            -s,s,-s,
                            s,s,-s,
                            -s,-s,-s,
                            s,-s,-s,
                            -s,s,s,
                            s,s,s,
                            -s,-s,s,
                            s,-s,s,
                        },
                        tris={
                            2,3,1, 2,4,3,
                            6,4,2, 6,8,4,
                            4,7,3, 8,7,4,
                            8,6,5, 7,8,5,
                            3,5,1, 7,5,3,
                            5,2,1, 5,6,2
                        },
                        uvs={
                            0,1,
                            1,1,
                            0,0,
                            1,0,
                            1,1,
                            0,1,
                            1,0,
                            0,0
                        },
                        uv_idx={
                            2,3,1, 2,4,3,
                            6,4,2, 6,8,4,
                            4,7,3, 8,7,4,
                            8,6,5, 7,8,5,
                            3,5,1, 7,5,3,
                            5,2,1, 5,6,2
                        }
                    }
                }
            end)
            geometry_module:set_entry(c3d.registry.entry("cube_skinned"),function(cust_scale)
                local s = cust_scale or s
                return BUS.object.generic_shape.new{
                    geometry = {
                        normal_idx = {
                            1,1,1, 1,1,1,
                            2,2,2, 2,2,2,
                            3,3,3, 3,3,3,
                            4,4,4, 4,4,4,
                            5,5,5, 5,5,5,
                            6,6,6, 6,6,6
                        },
                        vertices={
                            s,s,-s,
                            s,-s,-s,
                            s,s,s,
                            s,-s,s,
                            -s,s,-s,
                            -s,-s,-s,
                            -s,s,s,
                            -s,-s,s
                        },
                        uvs={
                            0.625,0.5,
                            0.875,0.5,
                            0.875,0.75,
                            0.625,0.75,
                            0.375,0.75,
                            0.625,1,
                            0.375,1,
                            0.375,0,
                            0.625,0,
                            0.625,0.25,
                            0.375,0.25,
                            0.125,0.5,
                            0.375,0.5,
                            0.125,0.75
                        },
                        uv_idx={
                            1,2,3,   1,3,4,
                            5,4,6,   5,6,7,
                            8,9,10,  8,10,11,
                            12,13,5, 12,5,14,
                            13,1,4,  13,4,5,
                            11,10,1, 11,1,13
                        },
                        tris={
                            1,5,7, 1,7,3,
                            4,3,7, 4,7,8,
                            8,7,5, 8,5,6,
                            6,2,4, 6,4,8,
                            2,1,3, 2,3,4,
                            6,5,1, 6,1,2
                        },
                        normals={
                            0,1,0,
                            0,0,1,
                            -1,0,0,
                            0,-1,0,
                            1,0,0,
                            0,0,-1
                        }
                    }
                }
            end)

            geometry_module:set_entry(c3d.registry.entry("load_model"),function(path)
                return BUS.object.imported_model.new(path)
            end)
        end

        geometry:register()
    end
end