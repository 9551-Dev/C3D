local cmgr     = require("core.cmgr")
local bus      = require("core.bus")
local handlers = require("core.handlers")

local screen_init = require("core.graphics.screen_init")

local update_thread = require("core.threads.update_thread")
local event_thread  = require("core.threads.event_thread")
local resize_thread = require("core.threads.resize_thread")
local key_thread    = require("core.threads.key_thread")
local tudp_thread   = require("core.threads.tupd_thread")

local per_matrix = require("core.3D.matrice.persperctive")

return function(ENV,libdir,...)
    local args = table.pack(...)
    local BUS = bus.register_bus(ENV)
    handlers.attach(ENV)
    BUS.instance.libdir = libdir

    local function start_execution(program,path,terminal,parent,ox,oy)

        local w,h = terminal.getSize()
        local ok = pcall(function()
            BUS.graphics.monitor = peripheral.getName(parent)
        end)
        if not ok then BUS.graphics.monitor = "term_object" end
        local sw,sh = w*2,h*3
        BUS.persperctive.matrix = per_matrix(sw,sh,
            BUS.persperctive.near,
            BUS.persperctive.far,
            BUS.persperctive.FOV
        )
        BUS.graphics.w,BUS.graphics.h = sw,sh
        BUS.graphics.display_source = terminal
        BUS.graphics.display = screen_init.new(BUS)
        BUS.graphics.event_offset = vector.new(ox,oy)
        BUS.clr_instance.update_palette(terminal)
        BUS.instance.gamedir = fs.getDir(path) or ""
        BUS.instance.gamepak = string.format(
            "/%s/modules/required/?.lua;/%s/?.lua;/rom/modules/main/?.lua",
            libdir,BUS.instance.gamedir
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
            ENV.package.path = BUS.instance.gamepak
            setfenv(program[1],ENV)(table.unpack(args,1,args.n))
            ENV.package.path = old_path
        else
            error(program[2],0)
        end

        local main   = update_thread.make(ENV,BUS,args)
        local event  = event_thread .make(ENV,BUS,args)
        local resize = resize_thread.make(ENV,BUS,parent)
        local key_h  = key_thread   .make(ENV,BUS)
        local tudp   = tudp_thread  .make(ENV,BUS)

        local ok,err = cmgr.start(BUS,function()
            return BUS.running
        end,{},main,event,resize,key_h,tudp)

        if not ok and ENV.c3d.errorhandler then
            if ENV.c3d.errorhandler(err) then
                error(err,2)
            end
        elseif not ok then
            error(err,2)
        end
    end

    BUS.object.palette        = require("core.objects.palette")       .add(BUS)
    BUS.object.texture        = require("core.objects.texture")       .add(BUS)
    BUS.object.scene_obj      = require("core.objects.scene_object")  .add(BUS)
    BUS.object.generic_shape  = require("core.objects.generic_shape") .add(BUS)
    BUS.object.camera         = require("core.objects.camera")        .add(BUS)
    BUS.object.imported_model = require("core.objects.imported_model").add(BUS)

    ENV.c3d.timer        = require("modules.timer")       (BUS)
    ENV.c3d.event        = require("modules.event")       (BUS)
    ENV.c3d.graphics     = require("modules.graphics")    (BUS)
    ENV.c3d.keyboard     = require("modules.keyboard")    (BUS)
    ENV.c3d.mouse        = require("modules.mouse")       (BUS)
    ENV.c3d.thread       = require("modules.thread")      (BUS)
    ENV.c3d.sys          = require("modules.sys")         (BUS)
    ENV.c3d.scene        = require("modules.scene")       (BUS)
    ENV.c3d.persperctive = require("modules.persperctive")(BUS)
    ENV.c3d.geometry     = require("modules.geometry")    (BUS)
    ENV.c3d.shader       = require("modules.shader")      (BUS)
    ENV.c3d.camera       = require("modules.camera")      (BUS)

    require("modules.c3d")(BUS,ENV)

    return start_execution
end