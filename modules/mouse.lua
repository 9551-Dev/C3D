local mouse = {}

return function(BUS)
    function mouse.get_position()
        return BUS.mouse.last_x, BUS.mouse.last_y
    end
    function mouse.get_x() return BUS.mouse.last_x end
    function mouse.get_y() return BUS.mouse.last_y end
    function mouse.is_down(...)
        local btn_list = {...}
        for k,key in pairs(btn_list) do
            local held = BUS.mouse.held[key]
            if not held then return false end
        end
        return true
    end
    function mouse.set_position(x,y)
        BUS.mouse.last_x = x
        BUS.mouse.last_y = y
    end
    function mouse.set_x(x) BUS.mouse.last_x = x end
    function mouse.set_y(y) BUS.mouse.last_y = y end
    return mouse
end
