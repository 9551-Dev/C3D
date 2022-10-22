local sqrt = math.sqrt
local cos  = math.cos
local sin  = math.sin
local rad  = math.rad

return function(x,y,z,a)
    local lenght = sqrt(x*x+y*y+z*z)

    if lenght == 0 then
        return {
            1,0,0,0,
            0,1,0,0,
            0,0,1,0,
            0,0,0,1
        }
    end

    local rad_a = rad(a)
    local w,s = cos(rad_a/2),sin(rad_a/2)

    local i = (x/lenght)*s
    local j = (y/lenght)*s
    local k = (z/lenght)*s

    return {
        1-2*j*j-2*k*k, 2*i*j+2*w*k, 2*i*k-2*w*j, 0,
        2*i*j-2*w*k, 1-2*i*i-2*k*k, 2*j*k+2*w*i, 0,
        2*i*k+2*w*j, 2*j*k-2*w*i, 1-2*i*i-2*j*j, 0,
        0, 0, 0, 1
    }
end