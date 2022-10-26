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
        cy*cz,(sx*sy*cz) +(cx*sz),(-cx*sy*cz)+(sx*sz),0,
        -cy*sz,(-sx*sy*sz)+(cx*cz),(cx*sy*sz) +(sx*cz),0,
        sy,-sx*cy,cx*cy,0,
        0,0,0,1
    }
end