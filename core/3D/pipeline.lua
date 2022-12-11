local modules = {
    triangle_asm = require("core.3D.stages.assemble_triangles"),
    vertex_sh    = require("core.3D.stages.vertex_shader"),
    vertex       = require("core.3D.stages.vertex")
}

local pairs = pairs
local epoch = os.epoch

return {create=function(BUS)
    BUS.pipeline = {
        modules.vertex,
        modules.vertex_sh,
        modules.triangle_asm,
    }

    BUS.log("  - Inicialized rendering pipeline",BUS.log.info)

    return {get_triangles = function()
        local pipeline = BUS.pipeline
        local camera   = BUS.camera
        local pipe_line_size = #pipeline
        local out = {n=0,tris={}}
        
        local timings = {}
        for stage=1,pipe_line_size do
            timings[stage] = 0
        end

        for k,object in pairs(BUS.scene) do
            local object_geometry    = object.geometry
            local object_effects     = object.effects
            local object_properties  = object.properties
            local object_texture     = object.texture

            local prev = {}

            for stage=1,pipe_line_size do

                local stage_begin = epoch("utc")

                prev = pipeline[stage](
                    object,
                    prev,
                    object_geometry,
                    object_properties,
                    object_effects,
                    out,
                    BUS,
                    object_texture,
                    camera
                )

                local stage_end = epoch("utc")

                timings[stage] = timings[stage] + stage_end-stage_begin
            end
        end

        BUS.graphics.stats.pipe = timings

        return out.tris
    end}
end}