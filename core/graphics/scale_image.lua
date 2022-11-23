local tbl = require("common.table_util")

return function(image,factor,w,h)
    local out_x,out_y = 0,0

    local output = tbl.createNDarray(1)

    for y=1,h,factor do
        out_y = out_y + 1
        out_x = 0
        for x=1,w,factor do
            out_x = out_x + 1
            output[out_y][out_x] = image[y][x]
        end
    end

    output.w,output.h = out_x,out_y

    return setmetatable(output,nil)
end