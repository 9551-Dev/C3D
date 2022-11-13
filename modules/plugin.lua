local plugin = {}

local generic = require("common.generic")

return function(BUS,ENV)
    function plugin.load(f,...)
        local args = table.pack(...)

        local id = generic.uuid4()
        local plugin_env = setmetatable({
            plug={new=function(name)
                BUS.log("Created new plugin -> "..name,BUS.log.debug)
                BUS.log:dump()
                return BUS.object.plugin.new(id,name)
            end},
            plugin={new=function(name)
                BUS.log("Created new plugin -> "..name,BUS.log.debug)
                BUS.log:dump()
                return BUS.object.plugin.new(id,name)
            end}
        },{__index=ENV})

        local ok,err = pcall(function()
            setfenv(f,plugin_env)(table.unpack(args,1,args.n))
        end)
        if not ok then
            error("Error loading plugin: "..tostring(err),0)
        end
    end

    function plugin.register()
        BUS.plugin_internal.register_modules()
        BUS.plugin_internal.register_objects()
        BUS.plugin_internal.register_threads()
    end
    function plugin.load_registered()
        BUS.plugin_internal.load_registered_modules()
        BUS.plugin_internal.load_registered_objects()
        BUS.plugin_internal.load_registered_threads()
    end

    function plugin.refinalize()
        BUS.plugin_internal.finalize_load()
    end

    return plugin
end