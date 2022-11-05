local ABS = math.abs

return function(bary_a,bary_b,bary_c,v1u,v1v,v2u,v2v,v3u,v3v)
    return v1u * bary_a + v2u * bary_b + v3u * bary_c,
        v1v    * bary_a + v2v * bary_b + v3v * bary_c
end