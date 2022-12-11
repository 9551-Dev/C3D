return {make=function(ENV,BUS)

    BUS.log("   - Created thread updater thread",BUS.log.success)
    BUS.log:dump()

    return coroutine.create(function()
        while true do
            local ev = table.pack(os.pullEventRaw())
            local has_thread_error_handle = type(ENV.c3d.threaderror) == "function" or type(BUS.triggers.overrides.threaderror) == "function"
            for k,v in pairs(BUS.thread.coro) do
                if not v.filter or v.filter == ev[1] and v.c and v.started then
                    local ok,ret = coroutine.resume(v.c,table.unpack(ev,1,ev.n))
                    local dead = coroutine.status(v.c) == "dead"
                    if ok and BUS.thread.coro[k] then BUS.thread.coro[k].filter = ret end
                    if not ok or dead then BUS.thread.coro[k] = nil end
                    if not ok and dead then
                        v.error = ret
                        if has_thread_error_handle then
                            (BUS.triggers.overrides.threaderror or ENV.c3d.threaderror)(v.object,ret)
                        end
                    end
                end
            end
        end
    end)
end}