local registry = {}

local memory_manager = require("core.mem_manager")

return function(BUS)

    local memory_handle = memory_manager.get(BUS)

    local memory_bus = BUS.memory

    function registry.get_table(category)
        if not memory_bus[category] then memory_handle.init_category(category) end
        return memory_handle.get_table(category or 4)
    end

    function registry.get_module_registry()
        return BUS.registry.module_registry
    end
    function registry.get_object_registry()
        return BUS.registry.object_registry
    end
    function registry.get_thread_registry()
        return BUS.registry.thread_registry
    end

    function registry.entry(name,value)
        return BUS.object.registry_entry.new(name,value)
    end
    
    return registry
end