local path = fs.getDir(select(2,...)):match("(.+)%/.+$")
local index = {
    error=1,
    warn=2,
    fatal=3,
    success=4,
    debug=5,
    message=6,
    update=7,
    info=8
}
local type_space = 15
local revIndex = {}
for k,v in pairs(index) do
    revIndex[v] = k
end
local function remove_time(str)
    local str = str:gsub("^%d-:% %[%d+:%d+:%d+% %d+]% ","")
    return str
end

local t_remove,max,ipairs = table.remove,math.max,ipairs

function index:dump()
    local lastLog = ""
    local nstr = 1
    local output_internal = {}
    local str = ""
    local longest = 0
    for _,v in ipairs(self.history) do
        if lastLog == remove_time(v.str)..v.type then
            nstr = nstr + 1
            t_remove(output_internal,#output_internal)
        else
            nstr = 1
        end

        longest = max(longest,#v.str)

        output_internal[#output_internal+1] = {str=v.str,count=nstr}
        lastLog = remove_time(v.str)..v.type
    end
    for _,v in ipairs(output_internal) do

        local padding = longest-#v.str+3

        str = str .. v.str .. (" "):rep(padding) .. ("("..v.count..")").. "\n"
    end
    local file = fs.open(path.."/c3d.log","w")
    file.write(str)
    file.close()
    return str
end
local function write_to_log_internal(self,str,type)
    local str = tostring(str)
    type = type or "info"
    local timeStr = tostring(#self.history+1)..": ["..(os.date("%T", os.epoch "local" / 1000) .. (".%03d"):format(os.epoch "local" % 1000)):gsub("%."," ").."] "
    local type_str = "["..(revIndex[type] or "info").."]"
    local base = timeStr..type_str..(" "):rep(type_space-#type_str-#tostring(#self.history+1)-1).."\127"..str

    if not (type == 5) or (type == 5 and self.bus.debug) then
        table.insert(self.history,{
            str=base,
            type=type
        })
    end
end
local function create_log_internal(BUS)
    local log = setmetatable({
        history={},
        bus=BUS
    },{
        __index=index,
        __call=write_to_log_internal
    })
    return log
end

return {create_log=create_log_internal}