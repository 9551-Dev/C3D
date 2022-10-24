local TAN = math.tan
local RAD = math.rad

return function(w,h,n,f,fov)
    local aspectRatio = 1/w * h
    local fov_rad = RAD(fov)

    return {
        aspectRatio/TAN(fov_rad*0.5),0,0,0,
        0,1/(TAN(fov_rad*0.5)),0,0,
        0,0,-f/(f-n),-1,
        0,0,-f*n/(f-n),1
    }
end