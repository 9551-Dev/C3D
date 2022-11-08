local pairs = pairs

return function(v1,v2,alpha)
    local v15 = v1[5]
    local v17 = v1[7]
    local vert = {
        (1 - alpha) * v1[1] + alpha * v2[1],
        (1 - alpha) * v1[2] + alpha * v2[2],
        (1 - alpha) * v1[3] + alpha * v2[3],
        (1 - alpha) * v1[4] + alpha * v2[4],
        0,0,0,0,
    }

    if v15 then
        vert[5] = (1 - alpha) * v15   + alpha * (v2[5] or 0)
        vert[6] = (1 - alpha) * v1[6] + alpha * (v2[6] or 0)
    end if v17 then
        vert[7] = (1 - alpha) * v17   + alpha * (v2[7] or 0)
        vert[8] = (1 - alpha) * v1[8] + alpha * (v2[8] or 0)
    end

    local v2frag = v2.frag
    if v1.frag and v2.frag then
        local new_frag = {}
        for k,v in pairs(v1.frag) do
            new_frag[k] = (1 - alpha) * v + alpha * v2frag[k]
        end
        vert.frag = new_frag
    end
    return vert
end