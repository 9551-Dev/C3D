local registry = {}

local object = require("core.object")

return function(BUS)

    function registry.get_module_registry()
        return BUS.registry.module_registry
    end

    function registry.entry(name,value)
        return BUS.object.registry_entry.new(name,value)
    end
    
    return registry
end