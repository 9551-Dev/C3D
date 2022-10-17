local geometry = {}

return function(BUS)

    local s = 0.5

    function geometry.cube_simple(cust_scale)
        local s = cust_scale or s
        return BUS.object.generic_shape.new{
            geometry={
                vertices={
                    -s,-s,-s,
                    s,-s,-s,
                    -s,s,-s,
                    s,s,-s,
                    -s,-s,s,
                    s,-s,s,
                    -s,s,s,
                    s,s,s,
                },
                tris={
                    1,3,2, 3,4,2,
                    2,4,6, 4,8,6,
                    3,7,4, 4,7,8,
                    5,6,8, 5,8,7,
                    1,5,3, 3,5,7,
                    1,2,5, 2,6,5
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
                }
            }
        }
    end

    function geometry.load_model(path)
        return BUS.object.imported_model.new(path)
    end

    return geometry
end