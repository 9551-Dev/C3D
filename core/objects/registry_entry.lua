local object = require("core.object")

local generic = require("common.generic")

return {add=function(BUS)

    local registry_entry_methods = {
        __index = object.new{
        },__tostring=function() return "registry_entry" end
    }

    return {new=function(name,value)
        local obj = {id=generic.uuid4(),name=name}

        return setmetatable(obj,registry_entry_methods):__build()
    end}
end}