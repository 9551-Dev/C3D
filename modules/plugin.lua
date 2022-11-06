local plugin = {}

local generic = require("common.generic")

return function(BUS,ENV)
    function plugin.load(f,...)
        local args = table.pack(...)

        local id = generic.uuid4()
        local plugin_env = setmetatable({
            plug={new=function(name)
                return BUS.object.plugin.new(id,name)
            end},
            plugin={new=function(name)
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

    return plugin
end