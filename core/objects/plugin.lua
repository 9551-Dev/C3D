local object = require("core.object")

return {add=function(BUS)

    local function attach_register(f,register_name,data)
        local plugin_env = setmetatable({
            [register_name]=data
        },{__index=BUS.ENV})
    
        return setfenv(f,plugin_env)
    end

    local plugin_methods = {
        __index = object.new{
            register=function(this)
                BUS.log("Registering plugin -> " .. this.PLUGID,BUS.log.debug)
                BUS.log:dump()
                if type(this.on_init_finish) == "function" then
                    BUS.triggers.on_full_load[#BUS.triggers.on_full_load+1] = this.on_init_finish
                end
                if type(this.register_objects) == "function" then
                    local oload = attach_register(this.register_objects,"OBJECT",BUS.registry.object_registry.entry_lookup)
                    BUS.plugin.objects[this.order][this.id] = oload
                end
                if type(this.register_modules) == "function" then
                    local mload = attach_register(this.register_modules,"MODULE",BUS.registry.module_registry.entry_lookup)
                    BUS.plugin.modules[this.order][this.id] = mload
                end
                if type(this.register_threads) == "function" then
                    BUS.plugin.threads[this.order][this.id] = this.register_threads
                end

            end,
            set_load_order=function(n)
                this.order = n
            end,
            get_bus=function()
                return BUS
            end,
            get_plugin_bus=function(this)
                return this.bus
            end
        },__tostring=function() return "plugin" end
    }

    return {new=function(id,registry_name)
        local allocated_bus = {}
        BUS.plugin.plugin_bus[registry_name] = allocated_bus

        local obj = {id=id,order=0,PLUGID=registry_name,bus=allocated_bus}

        BUS.registry.plugin_registry[registry_name] = id

        return setmetatable(obj,plugin_methods):__build()
    end}
end}