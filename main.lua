local cmgr     = require("core.cmgr")
local bus      = require("core.bus")
local handlers = require("core.handlers")

local screen_init = require("core.graphics.screen_init")

local update_thread = require("core.threads.update_thread")
local event_thread  = require("core.threads.event_thread")
local resize_thread = require("core.threads.resize_thread")
local key_thread    = require("core.threads.key_thread")
local tudp_thread   = require("core.threads.tupd_thread")

local per_matrix = require("core.3D.matrice.perspective")

return function(ENV,libdir,...)
    local args = table.pack(...)
    local BUS = bus.register_bus(ENV)
    handlers.attach(ENV)
    BUS.instance.libdir = libdir

    BUS.plugin_internal = require("core.plugin_api").init(BUS)

    local function start_execution(program,path,terminal,parent,ox,oy)

        local w,h = terminal.getSize()
        local ok = pcall(function()
            BUS.graphics.monitor = peripheral.getName(parent)
        end)
        if not ok then BUS.graphics.monitor = "term_object" end
        local sw,sh = w*2,h*3
        BUS.perspective.matrix = per_matrix(sw/2,sh/2,
            BUS.perspective.near,
            BUS.perspective.far,
            BUS.perspective.FOV
        )
        BUS.graphics.w,BUS.graphics.h = sw,sh
        BUS.graphics.display_source = terminal
        BUS.graphics.display = screen_init.new(BUS)
        BUS.graphics.screen_parent = parent
        BUS.graphics.event_offset = vector.new(ox,oy)
        BUS.clr_instance.update_palette(terminal)
        BUS.instance.scenedir = fs.getDir(path) or ""
        BUS.instance.scenepak = string.format(
            "/%s/modules/required/?.lua;/%s/?.lua;/rom/modules/main/?.lua",
            libdir,BUS.instance.scenedir
        )
        BUS.instance.libpak = string.format(
            "/%s/?.lua;/rom/modules/main/?.lua",
            libdir
        )
        for x,y in ENV.utils.table.map_iterator(BUS.graphics.w,BUS.graphics.h) do
            BUS.graphics.buffer[y][x] = colors.black
        end
        
        if type(program[1]) == "function" then
            local old_path = package.path
            ENV.package.path = BUS.instance.scenepak
            BUS.plugin_internal.load_registered_modules()
            setfenv(program[1],ENV)(table.unpack(args,1,args.n))
            ENV.package.path = old_path
        else
            error(program[2],0)
        end

        if type(ENV.c3d.init) == "function" then
            ENV.c3d.init()
            BUS.plugin_internal.register_modules()
        end

        local main   = update_thread.make(ENV,BUS,args)
        local event  = event_thread .make(ENV,BUS,args)
        local resize = resize_thread.make(ENV,BUS,function() return BUS.graphics.screen_parent end)
        local key_h  = key_thread   .make(ENV,BUS)
        local tudp   = tudp_thread  .make(ENV,BUS)

        BUS.plugin_internal.load_registered_modules()

        local ok,err = coroutine.resume(main)

        if ok then
            ok,err = cmgr.start(BUS,function()
                return BUS.running
            end,{},main,event,resize,key_h,tudp)
        end

        if parent.getGraphicsMode and parent.getGraphicsMode() == true then parent.setGraphicsMode(0) end

        if not ok and ENV.c3d.errorhandler then
            if ENV.c3d.errorhandler(err) then
                error(err,2)
            end
        elseif not ok then
            error(err,2)
        end
    end

    BUS.object.registry_entry   = require("core.objects.registry_entry")  .add(BUS)
    BUS.object.plugin           = require("core.objects.plugin")           .add(BUS)
    BUS.object.palette          = require("core.objects.palette")         .add(BUS)
    BUS.object.texture          = require("core.objects.texture")         .add(BUS)
    BUS.object.scene_obj        = require("core.objects.scene_object")    .add(BUS)
    BUS.object.generic_shape    = require("core.objects.generic_shape")   .add(BUS)
    BUS.object.camera           = require("core.objects.camera")          .add(BUS)
    BUS.object.imported_model   = require("core.objects.imported_model")  .add(BUS)
    BUS.object.vector           = require("core.objects.vector")          .add(BUS)
    BUS.object.animated_texture = require("core.objects.animated_texture").add(BUS)
    BUS.object.sprite_sheet     = require("core.objects.sprite_sheet")    .add(BUS)
    BUS.object.raw_mesh         = require("core.objects.raw_mesh")        .add(BUS)

    ENV.c3d.plugin       = require("modules.plugin")     (BUS,ENV)
    ENV.c3d.registry     = require("modules.registry")   (BUS)
    
    ENV.c3d.plugin.load(require("modules.timer")      (BUS))
    ENV.c3d.plugin.load(require("modules.event")      (BUS))
    ENV.c3d.plugin.load(require("modules.graphics")   (BUS))
    ENV.c3d.plugin.load(require("modules.keyboard")   (BUS))
    ENV.c3d.plugin.load(require("modules.mouse")      (BUS))
    ENV.c3d.plugin.load(require("modules.thread")     (BUS))
    ENV.c3d.plugin.load(require("modules.sys")        (BUS))
    ENV.c3d.plugin.load(require("modules.scene")      (BUS))
    ENV.c3d.plugin.load(require("modules.perspective")(BUS))
    ENV.c3d.plugin.load(require("modules.geometry")   (BUS))
    ENV.c3d.plugin.load(require("modules.shader")     (BUS))
    ENV.c3d.plugin.load(require("modules.camera")     (BUS))
    ENV.c3d.plugin.load(require("modules.pipe")       (BUS))
    ENV.c3d.plugin.load(require("modules.vector")     (BUS))
    ENV.c3d.plugin.load(require("modules.interact")   (BUS))
    ENV.c3d.plugin.load(require("modules.mesh")       (BUS))
    BUS.plugin_internal.register_modules()

    require("modules.c3d")(BUS,ENV)

    return start_execution
end