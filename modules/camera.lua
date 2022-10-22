local camera = {}

return function(BUS)
    local new_camera = BUS.object.camera.new()
        :set_position(0,0,0)
        :set_rotation(0,0,0)

    BUS.camera = new_camera

    function camera.set_position(x,y,z)
        BUS.camera:set_position(x,y,z)
    end
    function camera.set_rotation(rx,ry,rz,w)
        BUS.camera:set_rotation(rx,ry,rz,w)
    end

    function camera.make(x,y,z,rx,ry,rz,w)
        return BUS.object.camera.new()
            :set_position(x  or 0,y  or 0,z  or 0)
            :set_rotation(rx or 0,ry or 0,rz or 0,w or 0)
    end
    function camera.set(cam)
        BUS.camera = cam or new_camera
    end
    function camera.get()
        return BUS.camera
    end
    
    return camera
end