local function split_string(str,delimiter)
    local o = {}
    local n = 0
    for c in str:gmatch("([^"..delimiter.."]+)") do
        n = n + 1
        o[n] = c
    end
    return o
end


return function(str)
    local result = {}

    local current_material

    for c in str:gsub("\t",""):gmatch("[^\n]+") do
        local line_info = split_string(c,"% ")
        if line_info[1] == "newmtl" then
            current_material = line_info[2]
            result[current_material] = {}
        end
        if     line_info[1] == "Ka" then result[current_material].ambient  = {tonumber(line_info[2]),tonumber(line_info[3]),tonumber(line_info[4])}
        elseif line_info[1] == "Kd" then result[current_material].diffuse  = {tonumber(line_info[2]),tonumber(line_info[3]),tonumber(line_info[4])}
        elseif line_info[1] == "Ks" then result[current_material].specular = {tonumber(line_info[2]),tonumber(line_info[3]),tonumber(line_info[4])}

        elseif line_info[1] == "d" then result[current_material] .alpha =   tonumber(line_info[2])
        elseif line_info[1] == "Tr" then result[current_material].alpha = 1-tonumber(line_info[2])

        elseif line_info[1] == "Ns" then result[current_material].shininess = tonumber(line_info[2])

        elseif line_info[1] == "illum" then result[current_material].lighting_model = tonumber(line_info[2])

        elseif line_info[1] == "map_Kd" then result[current_material].texture_path = line_info[2] end
    end

    return result
end