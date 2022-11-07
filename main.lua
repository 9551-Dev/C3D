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

    local log = BUS.log

    BUS.plugin_internal = require("core.plugin_api").init(BUS)
    log("[ Inicialized plugin api ]",log.info)

    local function start_execution(program,path,terminal,parent,ox,oy)

        log("[ Getting terminal info ]",log.info)
        local w,h = terminal.getSize()
        local ok = pcall(function()
            BUS.graphics.monitor = peripheral.getName(parent)
        end)
        if not ok then BUS.graphics.monitor = "term_object" end

        log("  Type: "..BUS.graphics.monitor,log.debug)

        local sw,sh = w*2,h*3

        log("  Init size: "..sw.."x"..sh,log.debug)
        BUS.perspective.matrix = per_matrix(sw/2,sh/2,
            BUS.perspective.near,
            BUS.perspective.far,
            BUS.perspective.FOV
        )
        log("Created perspective matrix",log.debug)
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
        log("Updated BUS with new data",log.debug)

        BUS.log:dump()

        for x,y in ENV.utils.table.map_iterator(BUS.graphics.w,BUS.graphics.h) do
            BUS.graphics.buffer[y][x] = colors.black
        end
        log("Filled screenbuffer",log.debug)
        
        log("Attempting to load given program",log.info)
        if type(program[1]) == "function" then
            local old_path = package.path
            ENV.package.path = BUS.instance.scenepak
            BUS.plugin_internal.load_registered_modules()
            setfenv(program[1],ENV)(table.unpack(args,1,args.n))
            ENV.package.path = old_path
            log("Succesfully loaded program",log.success)
        else
            log("Failed to load program -> "..program[2],log.fatal)
            log:dump()
            error(program[2],0)
        end

        log:dump()

        if type(ENV.c3d.init) == "function" then
            log("Found c3d.init. re-registering plugins.",log.info)
            ENV.c3d.init()
            BUS.plugin_internal.register_modules()
            log("Successfuly registered plugins",log.success)
        end

        local main   = update_thread.make(ENV,BUS,args)
        local event  = event_thread .make(ENV,BUS,args)
        local resize = resize_thread.make(ENV,BUS,function() return BUS.graphics.screen_parent end)
        local key_h  = key_thread   .make(ENV,BUS)
        local tudp   = tudp_thread  .make(ENV,BUS)

        if type(ENV.c3d.init) == "function" then
            BUS.plugin_internal.load_registered_modules()
        end

        log("[ Resuming and getting data from the loaded program ]",log.info)
        local ok,err = coroutine.resume(main)
        local err_thread

        log:dump()

        if ok then
            log("[ C3D INIT SUCCESSFUL ]",log.success)
            log("[ STARTING EXECUTION ]",log.info)
            log("",log.info)

            log:dump()

            ok,err,err_thread = cmgr.start(BUS,function()
                return BUS.running
            end,{},main,event,resize,key_h,tudp)

            if not ok then
                local trace = "NO MORE INFO"
                if err_thread then trace = debug.traceback(err_thread) end

                log("[ A FATAL ERROR HAS OCCURED ] -> " .. tostring(err or ""):gsub("\n",""),log.fatal)
                for str in string.gmatch(trace:gsub("\t","%    "), "([^\n]+)") do
                    log(str,log.warn)
                end
                log("",log.info)
                log:dump()
            else
                log("[ C3D EXITED NORMALLY ]",log.success)
            end
            log:dump()
        else
            local trace = debug.traceback(main)
            log("[ C3D INIT FAILED ] -> "..tostring(err or ""),log.fatal)
            for str in string.gmatch(trace:gsub("\t","%    "), "([^\n]+)") do
                log(str,log.warn)
            end
            log("",log.info)
            log:dump()
        end

        if parent.getGraphicsMode and parent.getGraphicsMode() then parent.setGraphicsMode(0) end

        if not ok and ENV.c3d.errorhandler then
            if ENV.c3d.errorhandler(err) then
                log("[ C3D -> goodbye. ]",log.info)
                log:dump()
                error(err,2)
            end
        elseif not ok then
            log("[ C3D -> goodbye. ]",log.info)
            log:dump()
            error(err,2)
        end

        log("",log.info)
        log("[ C3D -> goodbye. ]",log.info)
        log:dump()
    end

    log("[ Loading internal objects.. ]",log.info)
    BUS.object.registry_entry   = require("core.objects.registry_entry")  .add(BUS)
    BUS.object.plugin           = require("core.objects.plugin")          .add(BUS)
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

    log("[ Loading plugin api modules.. ]",log.info)
    log("",log.info)
    ENV.c3d.plugin       = require("modules.plugin")     (BUS,ENV)
    ENV.c3d.registry     = require("modules.registry")   (BUS)
    
    log("[ Loading internal modules.. ]",log.info)
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
    ENV.c3d.plugin.load(require("modules.log")        (BUS))

    BUS.plugin_internal.register_modules()

    require("modules.c3d")(BUS,ENV)

    return start_execution
end