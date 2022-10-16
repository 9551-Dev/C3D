return function(v1,v2,alpha)
    return {
        (1 - alpha) * v1[1] + alpha * v2[1],
        (1 - alpha) * v1[2] + alpha * v2[2],
        (1 - alpha) * v1[3] + alpha * v2[3],
        (1 - alpha) * v1[4] + alpha * v2[4],
        (1 - alpha) * v1[5] + alpha * v2[5],
        (1 - alpha) * v1[6] + alpha * v2[6],
    }
end