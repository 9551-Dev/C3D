local args = {...}

local terminal = window.create(term.current(),1,1,term.getSize())

local ok,C3DData = pcall(require,"libC3D")
if not ok then error("C3D could not be loaded \n"..C3DData,0) end

local init_win,ox,oy = C3DData.util.window.get_parent_info(terminal)
local advice_api = "https://api.adviceslip.com/advice"

local function error_screen(err,is_C3D)
    local trace = debug.traceback()
    local tid = os.startTimer(0.1)
    local last = {init_win.getSize()}
    while true do
        local ev = table.pack(os.pullEvent())
        if ev[1] == "timer" and tid == ev[2] then

            terminal.setVisible(false)

            tid = os.startTimer(0.1)
            local w,h = init_win.getSize()

            if last[1] ~= w or last[2] ~= h then
                terminal.reposition(1,1,w,h)
            end

            terminal.setBackgroundColor(colors.blue)
            terminal.clear()
            terminal.setCursorPos(3,3)
            terminal.setBackgroundColor(colors.red)
            terminal.write(C3DData.util.string.ensure_size("C3D Error",w-4))

            terminal.setBackgroundColor(colors.blue)
            if is_C3D then terminal.setBackgroundColor(colors.red) end
            terminal.setCursorPos(3,5)
            local err_line_taking = C3DData.util.draw.respect_newlines(terminal,
            C3DData.util.string.wrap(err,w-4)
            )

            terminal.setBackgroundColor(colors.gray)
            terminal.setCursorPos(3,6+err_line_taking)
            C3DData.util.draw.respect_newlines(terminal,
                C3DData.util.string.ensure_line_size(
                    C3DData.util.string.wrap_lines(
                        C3DData.util.parse.stack_trace(trace),
                        w-4
                    ),
                w-4)
            )

            terminal.setBackgroundColor(colors.blue)
            terminal.setCursorPos(3,h-1)
            terminal.write("Press \"C\" to cry.")

            terminal.setVisible(true)
        elseif ev[1] == "key" and ev[2] == keys.c then
            init_win.setBackgroundColor(colors.black)
            init_win.clear()
            init_win.setCursorPos(1,1)
            break
        end
    end
end

local function no_scene_screen()
    local web = http.get(advice_api)
    local advice = "Try out GuiH !"
    if web then
        advice = textutils.unserializeJSON(web.readAll()).slip.advice
    end
    local tid = os.startTimer(0.1)
    local last = {init_win.getSize()}
    while true do
        local ev = table.pack(os.pullEvent())
        if ev[1] == "timer" and tid == ev[2] then

            terminal.setVisible(false)
            terminal.setBackgroundColor(colors.blue)
            terminal.clear()
            

            tid = os.startTimer(0.1)
            local w,h = init_win.getSize()

            if last[1] ~= w or last[2] ~= h then
                terminal.reposition(1,1,w,h)
            end

            terminal.setBackgroundColor(colors.red)
            terminal.setCursorPos(3,3)
            local lines = C3DData.util.draw.respect_newlines(terminal,
                C3DData.util.string.ensure_line_size(
                    C3DData.util.string.wrap("No scene.",w-4),
                w-4)
            )

            terminal.setBackgroundColor(colors.black)
            terminal.setCursorPos(3,4+lines)
            C3DData.util.draw.respect_newlines(terminal,
                C3DData.util.string.ensure_line_size(
                    C3DData.util.string.wrap("\""..advice.."\"",w-4),
                w-4)
            )
            terminal.setBackgroundColor(colors.blue)

            terminal.setCursorPos(3,h-1)
            C3DData.util.draw.respect_newlines(terminal,
                C3DData.util.string.wrap("Press enter to exit",w-4)
            )

            terminal.setVisible(true)

        elseif ev[1] == "key" and ev[2] == keys.enter then
            init_win.setBackgroundColor(colors.black)
            init_win.clear()
            init_win.setCursorPos(1,1)
            break
        end
    end
end

if not C3DData.init_ok then error_screen("Internal C3D error: " .. tostring(C3DData.env),true) end

local errored = true

local function run_f(f)
    local ok,err = pcall(C3DData.env,{f},"/main.lua",terminal,init_win,ox,oy)
    if not ok then error_screen("Runtime error: " .. tostring(err)) end
end

if not args[2] then
    local ok,err = pcall(function()
        if not next(args) then
            no_scene_screen()
            errored = true
        elseif not fs.exists(args[1]) or not fs.isDir(args[1]) then
            error_screen("Loading error: folder does not exist")
            errored = true
        elseif fs.exists(args[1]) and not fs.isDir(args[1]) then
            error_screen("Loading error: must be ran on a folder")
            errored = true
        elseif fs.exists(args[1]) and fs.isDir(args[1]) then
            local full_path = fs.combine(args[1],"main.lua")
            if fs.exists(full_path) then
                local ok,err = pcall(C3DData.env,{loadfile(full_path)},full_path,terminal,init_win,ox,oy)
                if not ok then error_screen("Runtime error: " .. tostring(err)) end
            else
                error_screen("Loading error: No code to run\nmake sure you have a main.lua file on the top level of the folder")
            end
        else errored = false end
    end)

    if not ok and not errored then
        error_screen("Runtime error: " .. err)
    elseif not ok then
        init_win.setBackgroundColor(colors.black)
        init_win.clear()
        init_win.setCursorPos(1,1)
    end
else return {run=run_f} end