local object = require("core.object")
local t_util = require("common.table_util")

local clr = require("common.color_util")

local t_unpack = table.unpack

return {new=function(BUS)
    local bg = BUS.graphics
    local disp = bg.display_source
    local methods = {__index=object.new{
        draw=function(this)
            for k,v in pairs(bg.render) do
                disp.setCursorPos(1,k)
                disp.blit(t_unpack(v))
            end
        end
    },{__tostring=function() return "screen" end}}

    local b = BUS.graphics
    local w,h = b.display_source.getSize()
    local vals = {BUS=BUS}
    vals.w,vals.h = w*2,h*3

    b.buffer  = t_util.createNDarray(1)

    return setmetatable(vals,methods):__build()
end}