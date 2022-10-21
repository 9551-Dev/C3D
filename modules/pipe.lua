local pipe = {}

local triangle_asm = require("core.3D.stages.assemble_triangles")
local geometry_sh  = require("core.3D.stages.geometry_shader")
local vertex_sh    = require("core.3D.stages.vertex_shader")
local vertex       = require("core.3D.stages.vertex")

local name_lookup = {
    vertex          = vertex,
    triangle_asm    = triangle_asm,
    geometry_shader = geometry_sh,
    vertex_shader   = vertex_sh,
}

local modes = {
    function(t) return t end,
    function(s)
        local out = {}
        local n = 0
        for c in s:gmatch("[^%->]+") do
            n = n + 1
            local nam = c:gsub(" ","")
            local res = name_lookup[nam]
            if not res then error(nam.."is not a valid pipeline element.",2) end
            out[n] = res
        end
        return out
    end,
    function(...)
        return {...} 
    end
}

return function(BUS)
    function pipe.triangle_asm()   return triangle_asm end
    function pipe.geomety_shader() return geometry_sh end
    function pipe.vertex_shader()  return vertex_sh end
    function pipe.vertex()         return vertex end

    function pipe.set(...)
        local t = {...}
        local mode = 1
        if type(t[1]) == "string" then
            mode = 2
        elseif type(t[1]) == "function" then
            mode = 3
        end

        BUS.pipeline = modes[mode](...)
    end

    function pipe.add_type(name,func)
        name_lookup[name] = func
    end

    return pipe
end
