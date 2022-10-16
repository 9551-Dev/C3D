local EXPECT = require("cc.expect").expect

local INT_BYTE_OFFSET = 0x30
local PPM = {INTERNAL={STRING={}}}

function PPM.INTERNAL.READ_BYTES_STREAM(stream,start,byte_count)
    local bytes = {}
    stream.seek("set",start)
    for i=start,start+byte_count-1 do
        local read = stream.read()
        table.insert(bytes,read)
    end
    return table.unpack(bytes)
end

function PPM.INTERNAL.READ_STRING_UNTIL_SEP(stream,pos)
    local str = ""
    stream.seek("set",pos)
    local byte = stream.read()
    if not byte then return false end
    while byte ~= 0x20 and byte ~= 0xA do
        str = str .. string.char(byte)
        byte = stream.read()
    end
    return str
end

function PPM.CHECK_COMMENT(stream,pos)
    stream.seek("set",pos)
    local byte = stream.read()
    if byte == 0x23 then
        while byte ~= 0xA do
            byte = stream.read()
        end
        return true
    end
    return false
end

function PPM.INTERNAL.READ_INT(stream,pos)
    local num = 0
    stream.seek("set",pos)
    local byte = stream.read()
    while byte ~= 0x20 and byte ~= 0xA do
        num = num * 10 + (byte-INT_BYTE_OFFSET)
        byte = stream.read()
    end
    return num
end

function PPM.INTERNAL.createNDarray(n, tbl)
    tbl = tbl or {}
    if n == 0 then return tbl end
    setmetatable(tbl, {__index = function(t, k)
        local new =  PPM.INTERNAL.createNDarray(n - 1)
        t[k] = new
        return new
    end})
    return tbl
end

local function comment(image)
    if not PPM.CHECK_COMMENT(image.stream,image.stream.seek("cur")) then
        image.stream.seek("set",image.stream.seek("cur")-1)
    end
end

function PPM.INTERNAL.DECODE(image)
    local out = PPM.INTERNAL.createNDarray(1)

    local header = PPM.INTERNAL.READ_STRING_UNTIL_SEP(image.stream,0)
    if not (header == "P6") then error("Invalid header/PPM file",2) end
    comment(image)
    local width  = PPM.INTERNAL.READ_INT(image.stream,image.stream.seek("cur"))
    local height = PPM.INTERNAL.READ_INT(image.stream,image.stream.seek("cur"))
    comment(image)
    local max_val = PPM.INTERNAL.READ_INT(image.stream,image.stream.seek("cur"))
    comment(image)

    for i=1,width*height do
        local r = image.stream.read()/max_val
        local g = image.stream.read()/max_val
        local b = image.stream.read()/max_val

        local x = math.ceil((i-1)%width+1)
        local y = math.ceil(i/width)
        out[y][x] = {r,g,b,(r+g+b)/3}
    end
    out.w = width
    out.h = height

    return out
end

function PPM.decode(file)
    local image = {}
    local stream = fs.open(file,"rb")
    if not stream then error("Could not open file",2) end
    local pos = stream.seek("cur")
    stream.seek("set",pos)
    image.stream = stream
    local dat = PPM.INTERNAL.DECODE(image)
    stream.close()
    return dat
end

return PPM.decode