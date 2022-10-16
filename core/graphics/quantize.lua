local tbutil = require("common.table_util")

local MAX = math.max
local MIN = math.min

return {build=function(BUS)
    local graphics = BUS.graphics

    local function get_most_channel(max,min)
        local diffs = {}
        for i=1,3 do
            diffs[i] = {val=max[i]-min[i],ind=i}
        end
        table.sort(diffs,function(a,b) return a.val > b.val end)
        return diffs[1].ind
    end

    local function add_color(c1,c2)
        return {
            c1[1] + c2[1],
            c1[2] + c2[2],
            c1[3] + c2[3],
        }
    end

    local function get_avg(total,count)
        return {
            total[1] / count,
            total[2] / count,
            total[3] / count
        }
    end

    return {quantize=function()
        local clrs = {}
        local clut = tbutil.createNDarray(2)
        for x,y in tbutil.map_iterator(graphics.w,graphics.h) do
            local c = graphics.buffer[y][x]
            if not clut[c[1]][c[2]][c[3]] then
                clrs[#clrs+1] = graphics.buffer[y][x]
                clut[c[1]][c[2]][c[3]] = true
            end
        end

        local function median_cut(tbl,parts,splited)
            if splited < 4 then
                local max = {
                    -math.huge,
                    -math.huge,
                    -math.huge,
                }
                local min = {
                    math.huge,
                    math.huge,
                    math.huge
                }
                local diffirences = tbutil.createNDarray(1)
                for k,v in pairs(tbl) do
                    for i=1,3 do
                        max[i] = MAX(max[i],v[i])
                        min[i] = MIN(min[i],v[i])
                        diffirences[k][i] = v[i]
                    end
                end
                local mchan = get_most_channel(max,min)
                table.sort(tbl,function(a,b)
                    return a[mchan] > b[mchan]
                end)

                local split = {{},{}}

                for i=1,#tbl do
                    local index = math.ceil((i*2)/#tbl)
                    local t = split[index]
                    t[#t+1] = tbl[i]
                end
                median_cut(split[1],parts,splited+1)
                median_cut(split[2],parts,splited+1)
            else
                local count = 0
                local total = {0,0,0}
                for k,v in pairs(tbl) do
                    total = add_color(v,total)
                    count = count + 1
                end
                parts[#parts+1] = get_avg(total,count)
            end
            return parts
        end

        if #clrs > 16 then
            local cut = median_cut(clrs,{},0)
            local res = BUS.sys.reserved_colors
            for i=1,#res do
                cut[#cut-i+1] = res[i]
            end
            return cut
        else return clrs end
    end}
end}