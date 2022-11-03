local object = require("core.object")

return {add=function(BUS)

        
    local texture_object = {
        __index = object.new{
            get_out=function(this)
                return this.c3d.option_result
            end,
            sprite_sheet=function(this,settings)
                return BUS.object.sprite_sheet.new(this,settings)
            end
        },__tostring=function() return "texture" end
    }

    return {new=function(path,options)
        local extension = path:match("^.+(%..+)$")
        local file_path = fs.combine(BUS.instance.scenedir,path)

        package.path = BUS.instance.libpak
        local parser = require("core.loaders.texture" .. extension)
        package.path = BUS.instance.scenepak

        local option_result = {}
        local fin = {}
        local data = parser.read(BUS,file_path,options or {},option_result,fin)
        data.c3d = {}
        data.c3d.option_result = option_result

        local obj = setmetatable(data,texture_object):__build()
        fin.returns = obj

        return obj
    end}
end}