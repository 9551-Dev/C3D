local int_vert = require("core.3D.geometry.interpolate_vertex")

return {init=function(BUS)

    local interpolate_vertex = int_vert.init(BUS)

    return function(object,n,tris,v1,v2,v3,fs,index,triangle_texture,pixel_size,z_layer,shader)
        local alpha1 = (-v1[3]) / (v3[3]-v1[3])
        local alpha2 = (-v2[3]) / (v3[3]-v2[3])

        local v10 = interpolate_vertex(v1,v3,alpha1)
        local v01 = interpolate_vertex(v2,v3,alpha2)

        local t1 = {v3,v01,v10,fs=fs,object=object,index=index,texture=triangle_texture,pixel_size=pixel_size,z_layer=z_layer,orig1=v1,orig2=v2,orig3=v3}
        if shader then t1 = shader(t1,index) end
        if t1 then
            tris[n+1] = t1
            return 1
        end
        return 0
    end
end}