local function build_run(c3d,args)
    if not c3d.run then
        function c3d.run()
            local BUS = c3d.sys.get_bus()
            local ds = BUS.graphics.display_source
            if BUS.triggers.overrides.load or c3d.load then (BUS.triggers.overrides.load or c3d.load)(table.unpack(args,1,args.n)) end
            if c3d.timer then c3d.timer.step() end
            local dt = 0

            return function()
                if c3d.event then
                    for name, a,b,c,d,e,f in c3d.event.poll() do
                        if name == "quit" then
                            if not (BUS.triggers.overrides.quit or c3d.quit) or not (BUS.triggers.overrides.quit or c3d.quit)() then
                                return a or 0
                            end
                        end
                        c3d.handlers[name](a,b,c,d,e,f)
                    end
                end
                if c3d.timer then dt = c3d.timer.step() end
                if BUS.triggers.overrides.update or c3d.update then (BUS.triggers.overrides.update or c3d.update)(dt) end
                ds.setVisible(false)
                c3d.graphics.clear_buffer(c3d.graphics.get_bg())

                if BUS.triggers.overrides.render or c3d.render then (BUS.triggers.overrides.render or c3d.render)() end
                BUS.plugin_internal.wake_trigger("pre_frame")
                c3d.graphics.render_frame()
                if c3d.timer then c3d.timer.sleep(c3d.sys.get_bus().sys.frame_time_min) end
                if BUS.triggers.overrides.postrender or c3d.postrender then (BUS.triggers.overrides.postrender or c3d.postrender)(ds) end
                BUS.plugin_internal.wake_trigger("post_display",ds)
                ds.setVisible(true)
            end
        end
    end
end

return build_run
