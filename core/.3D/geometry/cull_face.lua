return function(a,b,c)
    local i1,i2,i3 = a[1],a[2],a[4]

    local a1 = b[1]-i1
    local a2 = b[2]-i2
    local a3 = b[4]-i3

    local b1 = c[1]-i1
    local b2 = c[2]-i2
    local b3 = c[4]-i3

    return (a2*b3 - a3*b2)*i1+
        (a3*b1 - a1*b3)   *i2+
        (a1*b2 - a2*b1)   *i3
end