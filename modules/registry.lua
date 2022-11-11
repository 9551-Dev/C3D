local registry = {}

local object = require("core.object")

local memory_manager = require("core.mem_manager")

return function(BUS)

    local memory_handle = memory_manager.get(BUS)

    function registry.get_table()
        return memory_handle.get_table()
    end

    function registry.get_module_registry()
        return BUS.registry.module_registry
    end
    function registry.get_object_registry()
        return BUS.registry.object_registry
    end

    function registry.entry(name,value)
        return BUS.object.registry_entry.new(name,value)
    end
    
    return registry
end