local tbl = require("common.table_util")

local object = require("core.object")

local methods = {}

return {init=function(BUS)
    function methods.register_modules()
        BUS.log("[ Registering loaded modules.. ]",BUS.log.info)
        for k,v in tbl.iterate_order(BUS.plugin.modules) do
            for id,loader in pairs(v) do 
                BUS.plugin.modules[k][id] = nil
                local ok,err = pcall(loader,0)
                if not ok then
                    BUS.log("Error registering module. "..tostring(err),BUS.log.error)
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

    function methods.register_objects()
        BUS.log("[ Registering loaded objects.. ]",BUS.log.info)
        for k,v in tbl.iterate_order(BUS.plugin.objects) do
            for id,loader in pairs(v) do 
                BUS.plugin.objects[k][id] = nil
                local ok,err = pcall(loader,0)
                if not ok then
                    BUS.log("Error registering object. "..tostring(err),BUS.log.error)
                end
            end
        end
    end
    function methods.load_registered_objects()
        BUS.log("[ Loading registered objects ]",BUS.log.info)
        local busmoddata = BUS.registry.object_registry
        for object_name,entry_id in pairs(busmoddata.entry_lookup) do
            local object_entry = busmoddata.entries[entry_id]
            local metatable = {__index=object.new{},__tostring=function() return object_name end}
            local methods = metatable.__index
            for k,v in pairs(object_entry.__rest.metadata) do metatable[k] = v end
            if object_entry.__rest.constructor then

                BUS.log("Loading object "..object_name,BUS.log.debug)
                for entry_id,m_reg_entry in pairs(object_entry.__rest.entries) do
                    local entry_name = object_entry.__rest.name_lookup[entry_id]
                    methods[entry_name] = m_reg_entry
                end
                BUS.object[object_name] = setmetatable({
                    new=function(...)
                        return setmetatable(object_entry.__rest.constructor(...),metatable):__build()
                    end
                },{__tostring=function() return object_name.."_constructor" end})
            else

                BUS.log("Coulnt load object "..object_name..". No constructor found",BUS.log.error)
            end
        end
        BUS.log:dump()
    end

    function methods.register_threads()
        BUS.log("[ Registering loaded threads.. ]",BUS.log.info)
        for k,v in tbl.iterate_order(BUS.plugin.threads) do
            for id,loader in pairs(v) do 
                BUS.plugin.modules[k][id] = nil
                local ok,err = pcall(loader,0)
                if not ok then
                    BUS.log("Error registering thread. "..tostring(err),BUS.log.error)
                end
            end
        end
    end
    function methods.load_registered_threads()
        BUS.log("[ Loading registered threads ]",BUS.log.info)
        local busmoddata = BUS.registry.thread_registry
        for object_name,reg_entry in pairs(busmoddata.entry_lookup) do
            local object_entry = busmoddata.entries[reg_entry.id]

            BUS.log("loaded registered thread -> "..object_name,BUS.log.debug)
            BUS.threads[object_name] = {
                coro = coroutine.create(object_entry)
            }
        end
    end

    function methods.finalize_load()
        BUS.log("Finalizing plugin loading..",BUS.log.info)
        for k,v in pairs(BUS.triggers.on_full_load) do
            BUS.triggers.on_full_load[k] = nil
            local ok,err = pcall(v)
            if not ok then
                BUS.log("Failed to finilize plugin load -> "..err,BUS.log.error)
            end
        end
    end

    return methods
end}