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
    local result = {vertices={},tris={},uvs={},normals={},normal_idx={},uv_idx={},material_indexing={}}
    local vertices,a            = result.vertices,0
    local tris,b                = result.tris,0
    local uvs,d                 = result.uvs,0
    local normals,n             = result.normals,0
    local normal_idx,ndx        = result.normal_idx,0
    local uv_idx,udx            = result.uv_idx,0
    local material_indexing,mdx = result.material_indexing,0

    local material_name

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
        elseif line_info[1] == "vn" then
            n = n + 3
            normals[n-2] = tonumber(line_info[2])
            normals[n-1] = tonumber(line_info[3])
            normals[n]   = tonumber(line_info[4])
        elseif line_info[1] == "f" then
            local triangles_added = 1
            for i=2,#line_info do
                if i == 5 then
                    local b_orig = b
                    local ndx_orig = ndx
                    local udx_orig = udx
                    b = b + 2
                    ndx = ndx + 2
                    udx = udx + 2

                    tris[b-1] = tris[b_orig-2]
                    tris[b]   = tris[b_orig]

                    normal_idx[ndx-1] = normal_idx[ndx_orig-2]
                    normal_idx[ndx]   = normal_idx[ndx_orig]

                    uv_idx[udx-1] = uv_idx[udx_orig-2]
                    uv_idx[udx]   = uv_idx[udx_orig]

                    triangles_added = triangles_added + 1
                end


                b = b + 1
                local split = split_string(line_info[i], "/")
                local splt2 = split[2]
                local splt3 = split[3]

                if splt2 ~= "" then
                    udx = udx + 1
                    uv_idx[udx] = tonumber(splt2)
                end

                if splt3 ~= "" then
                    ndx = ndx + 1
                    normal_idx[ndx] = tonumber(splt3)
                end

                tris[b] = tonumber(split[1])
            end
            for i=1,triangles_added do
                mdx = mdx + 1
                material_indexing[mdx] = material_name
            end
        elseif line_info[1] == "usemtl" then
            material_name = line_info[2]
        end
    end

    return {geometry=result}
end

return decode