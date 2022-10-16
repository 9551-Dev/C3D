local shader = {default={},pixel={},vertex={},geometry={}}

local matmul = require("core.3D.math.matmul")

local RANDOM = math.random

return function(BUS)
    function shader.default.vertex(new_vertice,properties,scale,rot,pos,per)
        local scaled_vertice     = matmul(new_vertice,scale)
        local rotated_vertice    = matmul(scaled_vertice,rot)
        local translated_vertice = matmul(rotated_vertice,pos)
        return matmul(translated_vertice,per)
    end

    function shader.default.pixel(px_info)
        if px_info.texture then
            return px_info.texture[px_info.ty][px_info.tx]
        end

        return px_info.color or colors.red
    end

    function shader.default.geometry(triangle)
        return triangle
    end

    function shader.pixel.noise()
        return 2^(RANDOM(0,1)*15)
    end

    return shader
end