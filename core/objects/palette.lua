local quant_util = require("core.graphics.quantize")

return {add=function(BUS)

    return function()
        local palette = plugin.new("c3d:object->palette")

        function palette.register_objects()
            local object_registry = c3d.registry.get_object_registry()
            local palette_object  = object_registry:new_entry("palette")

            palette_object:set_entry(c3d.registry.entry("apply_palette"),function(this)
                for k,v in ipairs(this.pal) do
                    this.term.setPaletteColor(2^(k-1),v[1],v[2],v[3])
                end
                if this.fin then return this.fin.returns end
            end)
            palette_object:set_entry(c3d.registry.entry("add"),function(this,to_add)
                local tpal = this.pal
                local extend = #tpal
                for k,v in pairs(to_add.pal) do
                    extend = extend + 1
                    tpal[extend] = v
                end

                return this
            end)
            palette_object:set_entry(c3d.registry.entry("quantize"),function(this,amount)
                this.pal = quant_util.quantize_palette(this.pal,amount)

                return this
            end)
            palette_object:set_entry(c3d.registry.entry("get"),function(this)
                return this.pal
            end)

            palette_object:constructor(function(palette,returns)
                palette = palette or {}

                local obj = {term=BUS.graphics.display_source,pal=palette,fin=returns}

                return obj
            end)
        end

        palette:register()
    end
end}
