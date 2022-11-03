return function(a, b)
    local a1,a2,a3,a4 = a[1],a[2],a[3],a[4]

    return  {
        a1*b[1]+a2*b[5]+a3*b[9] +a4*b[13],
        a1*b[2]+a2*b[6]+a3*b[10]+a4*b[14],
        a1*b[3]+a2*b[7]+a3*b[11]+a4*b[15],
        a1*b[4]+a2*b[8]+a3*b[12]+a4*b[16]
    }
end