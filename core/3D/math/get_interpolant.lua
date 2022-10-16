return function(a,b,p)
    local v1 = {a[1]-b[1], a[2]-b[2]}
    local v2 = {a[1]-p[1], a[2]-p[2]}

    return (v1[1]*v2[1] + v1[2]*v2[2]) / (v1[1]*v1[1] + v1[2]*v1[2])
end