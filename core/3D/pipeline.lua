local modules = {
    triangle_asm = require("core.3D.stages.assemble_triangles"),
    geometry_sh  = require("core.3D.stages.geometry_shader"),
    vertex_sh    = require("core.3D.stages.vertex_shader"),
    vertex       = require("core.3D.stages.vertex")
}

local pairs = pairs

return {create=function(BUS)
    BUS.pipeline = {
        modules.vertex,
        modules.vertex_sh,
        modules.triangle_asm,
        modules.geometry_sh,
    }

    return {get_triangles = function()
        local pipeline = BUS.pipeline
        local camera   = BUS.camera
        local pipe_line_size = #pipeline
        local out = {n=0,tris={}}
        for k,object in pairs(BUS.scene) do
            local object_geometry   = object.geometry
            local object_effects    = object.effects
            local object_properties = object.properties
            local object_texture    = object.texture

            local prev = {}

            for i=1,pipe_line_size do
                prev = pipeline[i](
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
            end
        end
        return out.tris
    end}
end}