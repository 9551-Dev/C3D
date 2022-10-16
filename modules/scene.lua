local scene = {}

return function(BUS)
    local sc_bus = BUS.scene

    function scene.add_geometry(geom)
        return BUS.object.scene_obj.new(geom)
    end

    return scene
end