local interact = {}
local floor = math.floor

return function(BUS)
    local bus_interactions = BUS.interactions

    function interact.enable(state)
        BUS.interactions.running = state
    end

    function interact.get_triangle(x,y)
        local map = bus_interactions.map
        return map[floor(y)*3][floor(x)*2]
    end
    function interact.get_object(x,y)
        local map = bus_interactions.map
        return map[floor(y)*3][floor(x)*2].object
    end

    return interact
end