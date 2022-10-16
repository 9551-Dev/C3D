local wUtil = {}

function wUtil.get_parent_info(term_object)
    local event_offset_x,event_offset_y,deepest = 0,0,term_object
    pcall(function()
        local function get_ev_offset(terminal)
            local x,y = terminal.getPosition()
            event_offset_x = event_offset_x + (x-1)
            event_offset_y = event_offset_y + (y-1)
            local _,parent = debug.getupvalue(terminal.reposition,5)
            if parent.reposition and parent ~= term.current() then
                deepest = parent
                get_ev_offset(parent)
            elseif parent ~= nil then
                deepest = parent
            end
        end
        get_ev_offset(term_object)
    end)
    return deepest,event_offset_x,event_offset_y
end

return wUtil