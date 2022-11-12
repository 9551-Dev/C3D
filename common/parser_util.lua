local parse = {}

function parse.stack_trace(trace)
    trace = trace:gsub("stack traceback:","")
    local res = ""

    local noted_libc3d = false
    for c in trace:gmatch(".-\n") do
        if not c:match("libC3D/") then
            res = res .. c .. "\n"
        elseif not noted_libc3d then
            noted_libc3d = true
            res = res .. "(libC3D/..)"
        end
    end

    return res
end

return parse