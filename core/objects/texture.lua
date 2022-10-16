local object = require("core.object")

local tile_object = {
    __index = object.new{
    },__tostring=function() return "Tile" end
}

return {add=function(BUS)
    return {new=function(path)
        local extension = path:match("^.+(%..+)$")
        local file_path = fs.combine(BUS.instance.gamedir,path)

        package.path = BUS.instance.libpak
        local parser = require("core.loaders.texture" .. extension)
        package.path = BUS.instance.gamepak

        local data = parser.read(BUS,file_path)

        data.BUS = BUS

        return setmetatable(data,tile_object):__build()
    end}
end}