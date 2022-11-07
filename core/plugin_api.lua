local tbl = require("common.table_util")

local methods = {}

return {init=function(BUS)
    function methods.register_modules()
        BUS.log("[ Registering loaded modules.. ]",BUS.log.info)
        for k,v in tbl.iterate_order(BUS.plugin.modules) do
            for id,loader in pairs(v) do 
                BUS.plugin.modules[k][id] = nil
                local ok,err = pcall(loader,0)
                if not ok then
                    BUS.log("Error registering module. "..err,BUS.log.error)
                end
            end
        end
    end
    function methods.load_registered_modules()
        BUS.log("[ Loading registered modules ]",BUS.log.info)
        local busmoddata = BUS.registry.module_registry
        for module,entry_id in pairs(busmoddata.entry_lookup) do
            local module_entry = busmoddata.entries[entry_id]
            local features = {}

            BUS.log("Loading module "..module,BUS.log.debug)
            for entry_id,m_reg_entry in pairs(module_entry.__rest.entries) do
                local entry_name = module_entry.__rest.name_lookup[entry_id]
                features[entry_name] = m_reg_entry
            end
            BUS.c3d[module] = features
        end
    end

    return methods
end}