local sqrt = math.sqrt

local function cross(x1,y1,z1,x2,y2,z2)
    return y1*z2-z1*y2,
        z1*x2-x1*z2,
        x1*y2-y1*x2
end

local function dot(x1,y1,z1,x2,y2,z2)
    return x1*x2 + y1*y2 + z1*z2
end

local function normalize(x,y,z)
    local len = sqrt(x*x+y*y+z*z)
    return x/len,y/len,z/len
end

return function(fromx,fromy,fromz,atx,aty,atz)
    local nx,ny,nz = normalize(fromx-atx,fromy-aty,fromz-atz)
    local ux,uy,uz = normalize(cross(0,-1,0,nx,ny,nz))
    local vx,vy,vz = normalize(cross(nx,ny,nz,ux,uy,uz))

    return {
        ux,vx,nx,0,
        uy,vy,ny,0,
        uz,vz,nz,0,
        dot(-fromx,fromy,-fromz,ux,uy,uz),
        dot(-fromx,fromy,-fromz,vx,vy,vz),
        dot(-fromx,fromy,-fromz,nx,ny,nz),1
    }
end