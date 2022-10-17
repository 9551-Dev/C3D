local object = require("core.object")

return {add=function(BUS)

    local imported_model_object = {
        __index = object.new{
            make_geometry=function(this,scale)
                local ver = this.DATA.geometry.vertices
                for i=1,#ver do
                    ver[i] = ver[i]*scale
                end
                return BUS.object.generic_shape.new(this.DATA)
            end
        },__tostring=function() return "imported_model" end
    }

    return {new=function(path)

        local obj = {}

        local extension = path:match("^.+(%..+)$")
        local file_path = fs.combine(BUS.instance.scenedir,path)

        package.path = BUS.instance.libpak
        local parser = require("core.loaders.imported_model" .. extension)
        package.path = BUS.instance.scenepak

        obj.DATA = parser.read(BUS,file_path)

        return setmetatable(obj,imported_model_object):__build()
    end}
end}