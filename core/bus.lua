local object = require("core.object")

return {register_bus=function(ENV)

    local BUS = {
        timer={last_delta=0,temp_delta=0},
        c3d=ENV.c3d,
        ENV=ENV,
        frames={},
        events={},
        running=true,
        debug=false,
        graphics={
            buffer=ENV.utils.table.createNDarray(1),
            bg_col=colors.black,
            pixel_size=1,
            stats={
                frames_drawn=0,
            },
            auto_resize=true
        },
        thread={
            channel={},
            coro={}
        },
        mouse={
            last_x=0,
            last_y=0,
            held={}
        },
        keyboard={
            pressed_keys={},
            textinput=true
        },
        instance={},
        object={},
        sys={
            frame_time_min=0,
            init_time=os.epoch("utc"),
            run_time=0
        },
        perspective={
            near=0,
            far =1000,
            FOV =50
        },
        interactions={
            running=true,
            map=ENV.utils.table.createNDarray(1)
        },
        plugin={
            modules=ENV.utils.table.createNDarray(1),
            objects=ENV.utils.table.createNDarray(1),
            plugin_bus={}
        },
        registry={
            module_registry=setmetatable({},{__tostring=function() return "module_registry" end}),
            plugin_registry=setmetatable({},{__tostring=function() return "plugin_registry" end}),
            object_registry=setmetatable({},{__tostring=function() return "object_registry" end})
        },
        triggers={on_full_load={}},
        scene={},
        camera={},
        animated_texture={instances={}},
        mem={},
        m_n=0
    }

    local log = require("lib.logger").create_log(BUS)

    BUS.log = log

    log("[-- Starting C3D --]",log.info)
    log("[ Loaded data bus ]",log.success)

    local seen = {[BUS.log]=true,[BUS.c3d]=true,[BUS.ENV]=true}

    local function printout(dist,val)
        log:dump()
        for k,v in pairs(val) do
            if type(v) == "table" and not seen[v] then
                log((" "):rep(dist).."|"..k..("("..tostring(v)..")"),log.debug)
                seen[v] = true
                printout(dist+1,v)
            else
                log((" "):rep(dist).."|"..k.." -> "..tostring(v),log.debug)
            end
        end
        if next(val) then log("",log.debug) end
    end
    printout(1,BUS)
    log("",log.info)

    local module_registry_entry = {
        __index=object.new{
            set_entry=function(this,registry_entry,value)
                log("Created new entry in module registry -> "..this.__rest.name.." -> "..registry_entry.name,log.debug)

                this.__rest.entries[registry_entry.id] = value
                this.__rest.entry_lookup[registry_entry.name] = registry_entry
                this.__rest.name_lookup[registry_entry.id] = registry_entry.name
            end,
        },__tostring=function() return "module_registry_entry" end
    }

    local object_registry_entry = {
        __index=object.new{
            set_entry=function(this,registry_entry,value)
                log("Created new entry in object registry -> "..this.__rest.name.." -> "..registry_entry.name,log.debug)

                this.__rest.entries[registry_entry.id] = value
                this.__rest.entry_lookup[registry_entry.name] = registry_entry
                this.__rest.name_lookup[registry_entry.id] = registry_entry.name
            end,
            set_metadata=function(this,name,val)
                rawset(this.__rest.metadata,name,val)
            end,
            constructor=function(this,constructor_method)
                this.__rest.constructor = constructor_method
            end
        },__tostring=function() return "object_registry_entry" end
    }

    local module_registry_methods =  {
        __index=object.new{
            new_entry=function(this,name)

                log("Created new module registry entry -> "..name)
                log:dump()

                local id = ENV.utils.generic.uuid4()

                local dat = {}
                dat.__rest = {name=name,entries={},entry_lookup=dat,name_lookup={}}

                this.entries[id] = dat
                this.entry_lookup[name] = id

                return setmetatable(dat,module_registry_entry):__build()
            end,
            get=function(this,id)
                local entry = this.entries[id]

                return setmetatable(entry,module_registry_entry):__build()
            end
        },__tostring=function() return "module_registry" end
    }

    local object_registry_methods = {
        __index=object.new{
            new_entry=function(this,name)

                log("Created new object registry entry -> "..name)
                log:dump()

                local id = ENV.utils.generic.uuid4()

                local dat = {}
                dat.__rest = {name=name,entries={},entry_lookup=dat,name_lookup={},metadata={}}

                this.entries[id] = dat
                this.entry_lookup[name] = id

                return setmetatable(dat,object_registry_entry):__build()
            end,
            get=function(this,id)
                local entry = this.entries[id]

                return setmetatable(entry,object_registry_entry):__build()
            end
        },__tostring=function() return "object_registry" end
    }

    BUS.registry.module_registry = setmetatable({entries={},entry_lookup={}},module_registry_methods):__build()
    BUS.registry.object_registry = setmetatable({entries={},entry_lookup={}},object_registry_methods):__build()
    BUS.registry.plugin_registry = setmetatable({entries={},entry_lookup={}},{})
    log("[ Loaded plugin system ]",log.success)
    log("")

    log:dump()

    return BUS
end}
