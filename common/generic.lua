local generic = {}
function generic.uuid4()
    local random = math.random
    local template ='xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
    return string.gsub(template, '[xy]', function (c)
        return string.format('%x', c == 'x' and random(0, 0xf) or random(8, 0xb))
    end)
end

function generic.precise_sleep(t)
    local ftime = os.epoch("utc")+t*1000
    while os.epoch("utc") < ftime do
        os.queueEvent("waiting")
        os.pullEvent("waiting")
    end
end

function generic.piece_string(str)
    local out = {}
    local n = 0
    str:gsub(".",function(c)
        n = n + 1
        out[n] = c
    end)
    return out
end

generic.events_with_cords = {
    monitor_touch=true,
    mouse_click=true,
    mouse_drag=true,
    mouse_scroll=true,
    mouse_up=true,
    mouse_move=true
}

return generic