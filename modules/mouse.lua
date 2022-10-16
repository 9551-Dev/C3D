local mouse = {}

return function(BUS)
    function mouse.getCursor() end
    function mouse.getPosition()
        return BUS.mouse.last_x*2, BUS.mouse.last_y*3
    end
    function mouse.getRelativeMode()
        return BUS.mouse.relative_mode
    end
    function mouse.getX() return BUS.mouse.last_x*2 end
    function mouse.getY() return BUS.mouse.last_y*3 end
    function mouse.isCursorSupported() return false end
    function mouse.isDown(...)
        local btn_list = {...}
        for k,key in pairs(btn_list) do
            local held = BUS.mouse.held[key]
            if not held then return false end
        end
        return true
    end
    function mouse.isGrabbed() return BUS.mouse.grabbed end
    function mouse.isVisible() return BUS.mouse.visible end
    function mouse.newCursor() return nil end
    function mouse.setCursor(cursor) end
    function mouse.setGrabbed(grab) BUS.mouse.grabbed = grab end
    function mouse.setPosition(x,y)
        BUS.mouse.last_x = x
        BUS.mouse.last_y = y
    end
    function mouse.setRelativeMode(enable)
        BUS.mouse.relative_mode = enable
    end
    function mouse.setVisible(visible) BUS.mouse.visible = visible end
    function mouse.setX(x) BUS.mouse.last_x = x end
    function mouse.setY(y) BUS.mouse.last_y = y end
    return mouse
end