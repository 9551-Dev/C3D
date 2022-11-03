local object  = require("core.object")
local generic = require("common.generic")

return {add=function(BUS)

    local sys = BUS.sys

    local animated_texture_object = {
        __index = object.new{
            __update=function(this)
                local frame_duration = this.duration/this.sprites_collum
                local rt = sys.run_time

                if rt-this.last_updated >= frame_duration then
                    if this.current_sprite_index >= this.sprites_collum then
                        this.current_sprite_index = 0

                        if this.auto_stop then
                            this.running  = false
                            this.auto_stop = false
                        end
                    end

                    
                    this.last_updated = rt
                    this.current_sprite_index = this.current_sprite_index + 1
                end
                this.pixels = this.sprites[this.current_sprite_index][this.sprite_x_index]
            end,
            autoplay=function(this,enable)
                if not this.running and enable then
                    this.last_updated = sys.run_time
                    this.current_sprite_index = 1
                end
                this.running = enable
                return this
            end,
            play=function(this)
                this.auto_stop = true
                this.running = true
                this.current_sprite_index = 1
                this.last_updated = sys.run_time
                return this
            end,
            resume=function(this)
                this.running = true
                return this
            end,
            pause=function(this)
                this.running = false
                return this
            end,
            change_duration=function(this,duration)
                this.duration = duration
                return this
            end,
            set_frame=function(this,frame)
                this.current_sprite_index = frame
                return this
            end
        },__tostring=function() return "animated_texture" end
    }

    return {new=function(sprite_map,x,duration)
        local id = generic.uuid4()

        local obj = {
            w=sprite_map.sprite_width,
            h=sprite_map.sprite_height,
            sprites_collum=sprite_map.sprites_y,
            sprites=sprite_map.sprites,
            duration=duration,
            sprite_x_index=x,
            last_updated=BUS.sys.run_time,
            current_sprite_index=1,
            pixels=sprite_map.sprites[1][x],
            running=true
        }

        local finished_object = setmetatable(obj,animated_texture_object):__build()

        BUS.animated_texture.instances[id] = finished_object

        return finished_object
    end}
end}