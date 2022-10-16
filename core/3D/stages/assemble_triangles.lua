local frustum_handle = require("core.3D.geometry.clip_cull_frustum")
local pixel_shader_b = require("core.3D.stages.pixel_shader")

return function(object,prev,geo,prop,efx,out,BUS)
    local on = out.n
    local out_tris = out.tris

    local shader = efx.ps

    local tris = geo.tris
    for i=1,#tris,3 do
        local a = prev[tris[i]]
        local b = prev[tris[i+1]]
        local c = prev[tris[i+2]]

        on = frustum_handle(object,out_tris,a,b,c,on,pixel_shader_b(shader))
    end

    out.n = on
end