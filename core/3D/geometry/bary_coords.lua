return function(x,y,p1,p2,p3)
    local p11,p12 = p1[1],p1[2]
    local p21,p22 = p2[1],p2[2]
    local p31,p32 = p3[1],p3[2]

    local div = ((p22-p32)*(p11-p31) + (p31-p21)*(p12-p32))
    local bary_a = ((p22-p32)*(x-p31) + (p31-p21)*(y-p32)) / div
    local bary_b = ((p32-p12)*(x-p31) + (p11-p31)*(y-p32)) / div

    return {
        bary_a,
        bary_b,
        1-bary_a-bary_b
    }
end