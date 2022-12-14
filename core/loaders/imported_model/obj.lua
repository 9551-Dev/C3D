local wavefront = require("lib.wavefront")

return {read=function(model_path)
    local file = fs.open(model_path,"r")
    local data = file.readAll()
    file.close()

    return wavefront(data)
end}
