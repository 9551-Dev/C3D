return function(a,b,pa,pb)
    local v1x,v1y = a[1]-b[1], a[2]-b[2]
    local v2x,v2y = a[1]-pa,   a[2]-pb

    return (v1x*v2x + v1y*v2y) / (v1x*v1x + v1y*v1y)
end