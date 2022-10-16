return function(ps)
    if ps then return ps end

    return function(px_info)
        if px_info.texture then
            return px_info.texture[px_info.ty][px_info.tx]
        end

        return px_info.color or colors.red
    end
end