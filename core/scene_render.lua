local cull_triangle = require("core.3D.geometry.cull_face")
local pst           = require("core.3D.math.transform_point_screen")
local tbl           = require("common.table_util")

return {create=function(BUS,raster)
    local pipeline = require("core.3D.pipeline").create(BUS)

    return {render=function()
        local triangles = pipeline.get_triangles()
        local bus_g = BUS.graphics
        local canv = bus_g.buffer
        local psize = bus_g.pixel_size
        local w,h = bus_g.w/psize,bus_g.h/psize

        local depth_map = tbl.createNDarray(1)

        local INTERACT_MODE  = BUS.interactions.running
        local SCREEN_OBJECTS = tbl.createNDarray(1)
        
        for i=1,#triangles do
            local triangle = triangles[i]

            local a,b,c = triangle[1],triangle[2],triangle[3]

            local o = triangle.object

            local cull = cull_triangle(a,b,c)
            local cull_invert = o.invert_culling

            if (not cull_invert and cull > 0) or (o.invert_culling and cull < 0) or o.disable_culling then
                raster.triangle(triangle.fs,o,
                    pst(a,w,h),
                    pst(b,w,h),
                    pst(c,w,h),
                    o.texture,
                    function(x,y,z,c)
                        x,y = x*psize,y*psize

                        for x_offset=0,psize-1 do
                            for y_offset=0,psize-1 do
                                local x_pos = x - x_offset
                                local y_pos = y - y_offset

                                local dmx = depth_map[x_pos][y_pos]

                                if not dmx or dmx > z then
                                    canv[y_pos][x_pos] = c
                                    depth_map[x_pos][y_pos] = z

                                    if INTERACT_MODE then
                                        SCREEN_OBJECTS[y_pos][x_pos] = triangle
                                    end
                                end
                            end
                        end
                    end
                )
            end
        end
        if INTERACT_MODE then BUS.interactions.map = SCREEN_OBJECTS end
    end}
end}