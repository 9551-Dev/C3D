local object = require("core.object")

local quant_util = require("core.graphics.quantize")

return {add=function(BUS)

    local palette_object = {
        __index = object.new{
            apply_palette=function(this)
                for k,v in ipairs(this.pal) do
                    this.term.setPaletteColor(2^(k-1),v[1],v[2],v[3])
                end
                return this.fin.returns
            end,
            add=function(this,to_add)
                local tpal = this.pal
                local extend = #tpal
                for k,v in pairs(to_add.pal) do
                    extend = extend + 1
                    tpal[extend] = v
                end

                return this
            end,
            quantize=function(this,amount)
                this.pal = quant_util.quantize_palette(this.pal,amount)

                return this
            end,
            get=function(this)
                return this.pal
            end
        },__tostring=function() return "palette" end
    }

    return {new=function(palette,returns)
        palette = palette or {}

        local obj = {term=BUS.graphics.display_source,pal=palette,fin=returns}

        return setmetatable(obj,palette_object):__build()
    end}
end}