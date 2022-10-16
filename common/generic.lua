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

function generic.init_grid_point(grid,x,y,z)
    if not grid[y] then
        grid[y] = {}
        if z > 0 then
            grid[y].n = z
            grid[y].start = 1
        else
            grid[y].n = 1
            grid[y].start = z
        end
    end
    if not grid[y][z] then
        grid[y][z] = {}
        if z > 0 then
            grid[y][z].n = x
            grid[y][z].start = 1
        else
            grid[y][z].n = 1
            grid[y][z].start = x
        end
    end
    if y > grid.n then grid.n = y end
    if y < grid.start then grid.start = y end
    if z > grid[y].n then grid[y].n = z end
    if z < grid[y].start then grid[y].start = z end
    if x > grid[y][z].n then grid[y][z].n = x end
    if x < grid[y][z].start then grid[y][z].start = x end
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