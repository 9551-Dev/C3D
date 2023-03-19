return function(a1,a2,a3,a4,b)
    return a1*b[1]+a2*b[5]+a3*b[9]+a4*b[13],
        a1*b[2]+a2*b[6]+a3*b[10]+a4*b[14],
        a1*b[3]+a2*b[7]+a3*b[11]+a4*b[15],
        a1*b[4]+a2*b[8]+a3*b[12]+a4*b[16]
end

--[=[
local transform = 0--[[$TRANSFORM]]
vert_x = vert_x*transform[1]+vert_y*transform[5]+vert_z*transform[9] +vert_w*transform[13]
vert_y = vert_x*transform[2]+vert_y*transform[6]+vert_z*transform[10]+vert_w*transform[14]
vert_z = vert_x*transform[3]+vert_y*transform[7]+vert_z*transform[11]+vert_w*transform[15]
vert_w = vert_x*transform[4]+vert_y*transform[8]+vert_z*transform[12]+vert_w*transform[16]
]=]