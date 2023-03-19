local utils = require("common.generic")

return {add=function(BUS)

    return function()
        local pipeline = plugin.new("c3d:object->pipeline")

        function pipeline.register_objects()
            local object_registry = c3d.registry.get_object_registry()
            local pipeline_object = object_registry:new_entry("pipeline")

            pipeline_object:set_entry(c3d.registry.entry("render"),function(this,model,pixel_draw)
                
            end)

            pipeline_object:constructor(function(id_override)
                local id = id_override or utils.uuid4()
                local object = {id=id}

                BUS.pipe.pipelines[id] = object

                return object
            end)
        end

        pipeline:register()
    end
end}
