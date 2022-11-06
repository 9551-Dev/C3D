local tbl = require("common.table_util")

local methods = {}

return {init=function(BUS)
    function methods.register_modules()
        for k,v in tbl.iterate_order(BUS.plugin.modules) do
            for id,loader in pairs(v) do 
                BUS.plugin.modules[k][id] = nil
                loader()
            end
        end
    end
    function methods.load_registered_modules()
        local busmoddata = BUS.registry.module_registry
        for module,entry_id in pairs(busmoddata.entry_lookup) do
            local module_entry = busmoddata.entries[entry_id]
            local features = {}
            for entry_id,m_reg_entry in pairs(module_entry.__rest.entries) do
                local entry_name = module_entry.__rest.name_lookup[entry_id]
                features[entry_name] = m_reg_entry
            end
            BUS.c3d[module] = features
        end
    end

    return methods
end}