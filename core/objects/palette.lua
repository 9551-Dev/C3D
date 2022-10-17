local object = require("core.object")

return {add=function(BUS)

    local palette_object = {
        __index = object.new{
            apply_palette=function(this)
                for k,v in ipairs(this.pal) do
                    this.term.setPaletteColor(2^(k-1),v[1],v[2],v[3])
                end
                return this.fin.returns
            end,
            get=function(this)
                return this.pal
            end
        },__tostring=function() return "palette" end
    }

    return {new=function(palette,returns)
        local obj = {term=BUS.graphics.display_source,pal=palette,fin=returns}

        return setmetatable(obj,palette_object):__build()
    end}
end}