local cull_triangle  = require("core.3D.geometry.cull_face")
local pst            = require("core.3D.math.transform_point_screen")
local tbl            = require("common.table_util")
local memory_manager = require("core.mem_manager")

local t1,t2,t3 = {},{},{}

return {create=function(BUS,raster)
    local pipeline = require("core.3D.pipeline").create(BUS)
    local rasterize_triangle = raster.triangle
    local mem_handle = memory_manager.get(BUS)

    BUS.log("  - Inicialized scene renderer",BUS.log.info)

    return {render=function()
        local pipe_st = os.epoch("utc")
        local triangles = pipeline.get_triangles()
        local pipe_et = os.epoch("utc")

        local bus_g = BUS.graphics

        bus_g.stats.transform_time = pipe_et-pipe_st

        local canv = bus_g.buffer
        local depth_map = tbl.createNDarray(1)
        local psize = bus_g.pixel_size
        local w_orig = bus_g.w
        local h_orig = bus_g.h

        local INTERACT_MODE  = BUS.interactions.running
        local SCREEN_OBJECTS   = tbl.createNDarray(1)
        local SCREEN_OBJECTS_Z = tbl.createNDarray(1)

        local tri_count = #triangles
        bus_g.stats.triangles_proccesed = tri_count
        local triangles_drawn = 0
        local pixels_rasterized = 0

        
        local rastst = os.epoch("utc")

        local _force_z
        local _triangle_pixel_size
        local _triangle
        local instantiate_fragment

        local function render_pixel(x,y,z,c,is_transparent,fragment)
            z = _force_z or z

            pixels_rasterized = pixels_rasterized + 1

            x,y = x*_triangle_pixel_size,y*_triangle_pixel_size

            for x_offset=0,_triangle_pixel_size-1 do
                for y_offset=0,_triangle_pixel_size-1 do
                    local x_pos = x - x_offset
                    local y_pos = y - y_offset

                    local dmx = depth_map[x_pos]
                    local dmv = dmx[y_pos]
                    local dox = SCREEN_OBJECTS_Z[x_pos][y_pos]

                    if not dmv or dmv < z then
                        if not is_transparent then
                            canv[y_pos][x_pos] = c
                            dmx[y_pos] = z
                        end
                    end
                    if not dox or dox < z then
                        SCREEN_OBJECTS_Z[x_pos][y_pos] = z
                        if INTERACT_MODE then
                            if instantiate_fragment then
                                fragment.is_triangle = false
                                fragment.__triangle = _triangle
                                SCREEN_OBJECTS[y_pos][x_pos] = fragment
                            else
                                _triangle.is_triangle = true
                                SCREEN_OBJECTS[y_pos][x_pos] = _triangle
                            end
                        end
                    end
                end
            end
        end

        for i=1,tri_count do
            local triangle = triangles[i]

            local a,b,c = triangle[1],triangle[2],triangle[3]

            local o = triangle.object

            local cull = cull_triangle(a,b,c)
            local cull_invert = o.invert_culling

            _triangle_pixel_size = triangle.pixel_size or psize
            _force_z = triangle.z_layer
            _triangle = triangle
            instantiate_fragment = o.instantiate_fragment

            local w,h = w_orig/_triangle_pixel_size,h_orig/_triangle_pixel_size

            if (not cull_invert and cull > 0) or (o.invert_culling and cull < 0) or o.disable_culling then
                triangles_drawn = triangles_drawn + 1
                rasterize_triangle(triangle,
                    pst(a,w,h,t1),
                    pst(b,w,h,t2),
                    pst(c,w,h,t3),
                    _triangle_pixel_size,
                    render_pixel,
                    triangle.orig1,triangle.orig2,triangle.orig3
                )
            end
        end
        local rastet = os.epoch("utc")

        bus_g.stats.triangles_drawn   = triangles_drawn
        bus_g.stats.pixels_rasterized = pixels_rasterized
        bus_g.stats.rasterize_time    = rastet-rastst
        if INTERACT_MODE then BUS.interactions.map = SCREEN_OBJECTS end
    end}
end}