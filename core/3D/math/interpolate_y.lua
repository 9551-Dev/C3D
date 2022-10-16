return function(a,b,y)
    local oy = (b[2] - a[2])
    if oy == 0 then oy = 5e-50 end

    return a[1] + ((y - a[2]) * (b[1] - a[1])) / oy
end