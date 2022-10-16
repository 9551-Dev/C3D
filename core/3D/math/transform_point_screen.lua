return function(p,w,h)
    local inverse_z = 1/p[4]
    return {
        ( p[1]*inverse_z+1)*w/2,
        (-p[2]*inverse_z+1)*h/2,
        inverse_z,
        p[4],
        p[5]*inverse_z,
        p[6]*inverse_z
    }
end