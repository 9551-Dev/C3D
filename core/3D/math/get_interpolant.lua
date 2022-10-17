return function(a,b,pa,pb)
    local v1 = {a[1]-b[1], a[2]-b[2]}
    local v2 = {a[1]-pa,   a[2]-pb}

    return (v1[1]*v2[1] + v1[2]*v2[2]) / (v1[1]*v1[1] + v1[2]*v1[2])
end