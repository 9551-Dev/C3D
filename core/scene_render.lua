local cull_triangle  = require("core.3D.geometry.cull_face")
local pst            = require("core.3D.math.transform_point_screen")
local tbl            = require("common.table_util")
local memory_manager = require("core.mem_manager")

local t1,t2,t3 = {},{},{}

return {create=function(BUS,raster)
    local pipeline = require("core.3D.pipeline").create(BUS)
    local mem_handle = memory_manager.get(BUS)

    BUS.log("  - Inicialized scene renderer",BUS.log.info)

    return {render=function()
        local pipe_st = os.epoch("utc")
        local triangles = pipeline.get_triangles()
        local pipe_et = os.epoch("utc")

        local bus_g = BUS.graphics

        bus_g.stats.transform_time = pipe_et-pipe_st

        local canv = bus_g.buffer
        local psize = bus_g.pixel_size
        local w_orig = bus_g.w
        local h_orig = bus_g.h

        local function draw_pixel()
        end

        local INTERACT_MODE  = BUS.interactions.running

        local tri_count = #triangles
        bus_g.stats.triangles_proccesed = tri_count
        local triangles_drawn = 0
        local pixels_rasterized = 0

        
        local rastst = os.epoch("utc")

        local _triangle_pixel_size

        local scene     = BUS.scene
        local pipelines = BUS.pipe.pipelines

        for id,model in pairs(scene) do
            local pipeline_id = model.pipeline.id

            pipelines[pipeline_id]:render(model,draw_pixel)
        end
        local rastet = os.epoch("utc")

        bus_g.stats.triangles_drawn   = triangles_drawn
        bus_g.stats.pixels_rasterized = pixels_rasterized
        bus_g.stats.rasterize_time    = rastet-rastst
    end}
end}