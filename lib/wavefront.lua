local function split_string(str,delimiter)
    local o = {}
    local n = 0
    for c in str:gmatch("([^"..delimiter.."]+)") do
        n = n + 1
        o[n] = c
    end
    return o
end

local function decode(str)
    local result = {vertices={},tris={},uvs={}}
    local vertices,a = result.vertices,0
    local tris,b     = result.tris,0
    local uvs,d      = result.uvs,0

    for c in str:gmatch("[^\n]+") do
        local line_info = split_string(c,"% ")
        if line_info[1] == "v" then
            a = a + 3

            vertices[a-2] = tonumber(line_info[2])
            vertices[a-1] = tonumber(line_info[3])
            vertices[a]   = tonumber(line_info[4])
        elseif line_info[1] == "vt" then
            d = d + 2
            uvs[d-1] = tonumber(line_info[2])
            uvs[d]   = tonumber(line_info[3])
        elseif line_info[1] == "f" then
            for i=2, #line_info do
                b = b + 1
                local split = split_string(line_info[i], "/")
                tris[b] = tonumber(split[1])
            end
        end
    end

    return {geometry=result}
end

return decode