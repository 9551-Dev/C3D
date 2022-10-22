local RAD,SIN,COS = math.rad,math.sin,math.cos

return function(rx,ry,rz)
    local x = RAD(rx)
    local y = RAD(ry)
    local z = RAD(rz)
    local sx = SIN(x)
    local sy = SIN(y)
    local sz = SIN(z)
    
    local cx = COS(x)
    local cy = COS(y)
    local cz = COS(z)

    return {
        cy*cz,-cy*sz,sy,0,
        (sx*sy*cz) +(cx*sz),(-sx*sy*sz)+(cx*cz),-sx*cy,0,
        (-cx*sy*cz)+(sx*sz),(cx*sy*sz) +(sx*cz),cx*cy, 0,
        0,0,0,1
    }
end