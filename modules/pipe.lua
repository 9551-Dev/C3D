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

    return function()
        local pipe = plugin.new("c3d:module->pipe")
        
        function pipe.register_modules()
            local module_registry = c3d.registry.get_module_registry()
            local pipe_module     = module_registry:new_entry("pipe")

            pipe_module:set_entry(c3d.registry.entry("triangle_asm")  , function() return triangle_asm end)
            pipe_module:set_entry(c3d.registry.entry("geometry_shader"),function() return geometry_sh  end)
            pipe_module:set_entry(c3d.registry.entry("vertex_shader"),  function() return vertex_sh    end)
            pipe_module:set_entry(c3d.registry.entry("vertex"),         function() return vertex       end)

            pipe_module:set_entry(c3d.registry.entry("set"),function(...)
                local t = {...}
                local mode = 1
                if type(t[1]) == "string" then
                    mode = 2
                elseif type(t[1]) == "function" then
                    mode = 3
                end

                BUS.pipeline = modes[mode](...)
            end)

            pipe_module:set_entry(c3d.registry.entry("add_type"),function(name,func)
                name_lookup[name] = func
            end)
        end

        pipe:register()
    end
end