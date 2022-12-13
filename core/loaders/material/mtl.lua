local wave_material = require("lib.wave_material")

return {read=function(model_path)
    local file = fs.open(model_path,"r")
    local data = file.readAll()
    file.close()

    return wave_material(data)
end}