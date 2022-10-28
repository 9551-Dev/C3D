local ABS = math.abs

return function(bary,uv1,uv2,uv3)
    local b1,b2,b3 = bary[1],bary[2],bary[3]
    return {
        uv1[5] * b1 + uv2[5] * b2 + uv3[5] * b3,
        uv1[6] * b1 + uv2[6] * b2 + uv3[6] * b3
    }
end