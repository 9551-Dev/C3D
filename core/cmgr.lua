local lib_cmgr = {}
local newline = "\n"

function lib_cmgr.add_thread_pointer(threads,f)
    local t = {coro=coroutine.create(f)}
    threads[t] = t
end

local function unpack_ev(e)
    return table.unpack(e,1,e.n)
end

function lib_cmgr.start(BUS,toggle,thread_pointer,main_thread,...)

    BUS.log("[CMGR]> Starting",BUS.log.info)
    BUS.log:dump()

    local static_threads = {...}
    local static_thread_filters = {}
    local main_filter
    local e
    local e_thread
    while coroutine.status(main_thread) ~= "dead" and type(e) == "nil" and toggle() do
        local ev = table.pack(os.pullEventRaw())
        if ev[1] == "terminate" then
            if type(BUS.c3d.quit)  == "function" or type(BUS.triggers.overrides.quit) == "function" then
                if not (BUS.triggers.overrides.quit or BUS.c3d.quit)() then
                    e = "Terminated"
                end
            else e = "Terminated" end
        else
            if ev[1] == main_filter or not main_filter then
                local ok,ret = coroutine.resume(main_thread,unpack_ev(ev))
                if ok then main_filter = ret end
                if not ok and coroutine.status(main_thread) == "dead" then
                    e = "Error in main thread "..newline..tostring(ret)
                    e_thread = main_thread
                end
            end
            for k,v in pairs(static_threads) do
                local f = static_thread_filters[k]
                if ev[1] == f or not f then
                    if coroutine.status(v) ~= "dead" then
                        local ok,ret = coroutine.resume(v,unpack_ev(ev))
                        if ok then static_thread_filters[k] = ret end
                        if not ok and coroutine.status(v) == "dead" then
                            e = ret
                            e_thread = v
                        end
                    else static_threads[k] = nil end
                end
            end
            for k,v in pairs(thread_pointer) do
                local filter = v.filter
                if ev[1] == filter or not filter then
                    if coroutine.status(v.coro) ~= "dead" then
                        local ok,ret = coroutine.resume(v.coro,unpack_ev(ev))
                        if ok then thread_pointer[k].filter = ret end
                        if not ok and coroutine.status(v.coro) == "dead" then
                            e = ret
                            e_thread = v.coro
                        end
                    else thread_pointer[k] = nil end
                end
            end
        end
    end

    BUS.log("[CMGR]> Stopping execution",BUS.log.warn)

    local disp =  BUS.graphics.screen_parent

    BUS.log("[CMGR]> Restoring palette and graphics mode",BUS.log.info)
    if disp.getGraphicsMode and disp.getGraphicsMode() then disp.setGraphicsMode(0) end

    for i=0,15 do
        local c = 2^i
        BUS.graphics.display_source.setPaletteColor(c,term.nativePaletteColor(c))
    end

    if toggle() then return false,tostring(e),e_thread end
    return true
end

return lib_cmgr