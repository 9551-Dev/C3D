local cull_triangle  = require("core.3D.geometry.cull_face")
local pst            = require("core.3D.math.transform_point_screen")
local tbl            = require("common.table_util")
local memory_manager = require("core.mem_manager")

local t1,t2,t3 = {},{},{}

return {create=function(BUS,raster)
    local mem_handle = memory_manager.get(BUS)

    BUS.log("  - Inicialized scene renderer",BUS.log.info)

    return {render=function()
        local pipe_st = os.epoch("utc")
        local pipe_et = os.epoch("utc")

        local bus_g = BUS.graphics

        bus_g.stats.transform_time = pipe_et-pipe_st

        local canv = bus_g.buffer
        local psize = bus_g.pixel_size
        local w_orig = bus_g.w
        local h_orig = bus_g.h

        local depth_map = tbl.createNDarray(1)

        local function draw_pixel(x,y,depth,id)
            if not depth_map[y][x] then depth_map[y][x] = depth end

            if depth_map[y][x] >= depth then
                canv[y][x] = 2^id
                depth_map[y][x] = depth
            end
        end

        local INTERACT_MODE  = BUS.interactions.running

        local triangles_drawn = 0
        local pixels_rasterized = 0

        
        local rastst = os.epoch("utc")

        local _triangle_pixel_size

        local scene     = BUS.scene
        local pipelines = BUS.pipe.pipelines

        local camera = BUS.camera
        local camera_transform = camera.transform
        local camera_rotation  = camera.rotation
        local camera_position  = camera.position

        local perspective = BUS.perspective.matrix

        for id,model in pairs(scene) do
            local pipeline_id = model.pipeline.id

            pipelines[pipeline_id]:render(model,w_orig,h_orig,camera_position,camera_rotation,camera_transform,perspective,draw_pixel)
        end

        local rastet = os.epoch("utc")

        bus_g.stats.triangles_drawn   = triangles_drawn
        bus_g.stats.pixels_rasterized = pixels_rasterized
        bus_g.stats.rasterize_time    = rastet-rastst
    end}
end}