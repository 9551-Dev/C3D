local cull_triangle = require("core.3D.geometry.cull_face")
local pst           = require("core.3D.math.transform_point_screen")
local tbl           = require("common.table_util")

return {create=function(BUS,raster)
    local pipeline = require("core.3D.pipeline").create(BUS)

    return {render=function()
        local triangles = pipeline.get_triangles()
        local bus_g = BUS.graphics
        local canv = bus_g.buffer
        local w,h = bus_g.w,bus_g.h

        local depth_map = tbl.createNDarray(1)
        
        for i=1,#triangles do
            local triangle = triangles[i]

            local a,b,c = triangle[1],triangle[2],triangle[3]

            local o = triangle.object

            local cull = cull_triangle(a,b,c)
            local cull_invert = o.invert_culling

            if (not cull_invert and cull > 0) or (o.invert_culling and cull < 0) or o.disable_culling then
                raster.triangle(triangle.ps,o,
                    pst(a,w,h),
                    pst(b,w,h),
                    pst(c,w,h),
                    o.texture,
                    function(x,y,z,c)
                        if not depth_map[x][y] or depth_map[x][y] > z then
                            canv[y][x] = c
                            depth_map[x][y] = z
                        end
                    end
                )
            end
        end
    end}
end}