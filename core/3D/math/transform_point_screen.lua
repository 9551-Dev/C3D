local pairs = pairs

return function(p,w,h,t)
    local inverse_z = 1/p[4]

    local new_frag = {}
    if p.frag then for k,v in pairs(p.frag) do
        new_frag[k] = v*inverse_z
    end end

    t[1] = ( p[1]*inverse_z+1)*w/2
    t[2] = (-p[2]*inverse_z+1)*h/2
    t[3] = inverse_z
    t[4] = p[4]
    t[5] = (p[5] or 0)*inverse_z
    t[6] = (p[6] or 0)*inverse_z
    t.frag = new_frag

    return t
end