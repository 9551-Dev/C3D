local object = require("core.object")

return {register_bus=function(ENV)

    local BUS = {
        timer={last_delta=0,temp_delta=0},
        c3d=ENV.c3d,
        ENV=ENV,
        frames={},
        events={},
        running=true,
        graphics={
            buffer=ENV.utils.table.createNDarray(1),
            bg_col=colors.black,
            pixel_size=1,
            stats={
                frames_drawn=0
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
            frame_time_min=1/30,
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
        },
        scene={},
        camera={},
        animated_texture={instances={}}
    }

    local module_registry_entry = {
        __index=object.new{
            set_entry=function(this,registry_entry,value)
                local id = ENV.utils.generic.uuid4()
                this.__rest.entries[registry_entry.id] = value
                this.__rest.entry_lookup[registry_entry.name] = registry_entry
                this.__rest.name_lookup[registry_entry.id] = registry_entry.name
            end,
        },__tostring=function() return "module_registry_entry" end
    }

    local module_registry_methods =  {
        __index=object.new{
            new_entry=function(this,name)
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

    BUS.registry.module_registry = setmetatable({entries={},entry_lookup={}},module_registry_methods):__build()
    BUS.registry.plugin_registry = setmetatable({entries={},entry_lookup={}},{})

    return BUS
end}
