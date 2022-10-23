local vector = {}

return function(BUS)
    function vector.new(x,y,z)
        return BUS.object.vector.new(x,y,z)
    end

    return vector
end