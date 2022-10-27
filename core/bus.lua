return {register_bus=function(ENV)
    return {
        timer={last_delta=0,temp_delta=0},
        c3d=ENV.c3d,
        ENV=ENV,
        frames={},
        events={},
        running=true,
        graphics={
            buffer=ENV.utils.table.createNDarray(1),
            bg_col=colors.black,
            blending={mode="alpha",alphamode="alphamultiply"},
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
            frame_time_min=1/60,
        },
        perspective={
            near=-0.5,
            far =1000,
            FOV =50
        },
        interactions={
            running=true,
            map=ENV.utils.table.createNDarray(1)
        },
        scene={},
        camera={}
    }
end}
