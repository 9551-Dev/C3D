local mouse = {}

return function(BUS)
    function mouse.getPosition()
        return BUS.mouse.last_x, BUS.mouse.last_y
    end
    function mouse.getX() return BUS.mouse.last_x end
    function mouse.getY() return BUS.mouse.last_y end
    function mouse.isDown(...)
        local btn_list = {...}
        for k,key in pairs(btn_list) do
            local held = BUS.mouse.held[key]
            if not held then return false end
        end
        return true
    end
    function mouse.setPosition(x,y)
        BUS.mouse.last_x = x
        BUS.mouse.last_y = y
    end
    function mouse.setX(x) BUS.mouse.last_x = x end
    function mouse.setY(y) BUS.mouse.last_y = y end
    return mouse
end
