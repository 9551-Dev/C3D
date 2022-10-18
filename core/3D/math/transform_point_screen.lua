local pairs = pairs

return function(p,w,h)
    local inverse_z = 1/p[4]

    local new_frag = {}
    if p.frag then for k,v in pairs(p.frag) do
        new_frag[k] = v*inverse_z
    end end

    return {
        ( p[1]*inverse_z+1)*w/2,
        (-p[2]*inverse_z+1)*h/2,
        inverse_z,
        p[4],
        p[5]*inverse_z,
        p[6]*inverse_z,
        frag=new_frag
    }
end