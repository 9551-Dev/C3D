local pairs = pairs
local memory_manager = require("core.mem_manager")

return {init=function(BUS)

    local memory_handle = memory_manager.get(BUS)

    return function(v1,v2,alpha)
        local v15 = v1[5]
        local v17 = v1[7]

        local out = memory_handle.get_table(1)

        out[1] = (1 - alpha) * v1[1] + alpha * v2[1]
        out[2] = (1 - alpha) * v1[2] + alpha * v2[2]
        out[3] = (1 - alpha) * v1[3] + alpha * v2[3]
        out[4] = (1 - alpha) * v1[4] + alpha * v2[4]

        if v15 then
            out[5] = (1 - alpha) * v15   + alpha * (v2[5] or 0)
            out[6] = (1 - alpha) * v1[6] + alpha * (v2[6] or 0)
        else out[5],out[6] = 0,0 end
        if v17 then
            out[7] = (1 - alpha) * v17   + alpha * (v2[7] or 0)
            out[8] = (1 - alpha) * v1[8] + alpha * (v2[8] or 0)
        else out[7],out[8] = 0,0 end

        if v1.norm and v2.norm then
            local new_normal = memory_handle.get_table(1)

            local n1,n2 = v1.norm,v2.norm
            new_normal[1] = (1 - alpha) * n1[1] + alpha * n2[1]
            new_normal[2] = (1 - alpha) * n1[2] + alpha * n2[2]
            new_normal[3] = (1 - alpha) * n1[3] + alpha * n2[3]

            out.norm = new_normal
        end

        local v2frag = v2.frag
        if v1.frag and v2frag then
            local new_frag = {}
            for k,v in pairs(v1.frag) do
                local second = v2frag[k]
                if second then new_frag[k] = (1 - alpha) * v + alpha * v2frag[k] end
            end
            out.frag = new_frag
        end

        return out
    end
end}