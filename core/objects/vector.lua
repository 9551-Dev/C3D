local matmul = require("core.3D.math.matmul")

local scale_matrice     = require("core.3D.matrice.scale")
local euler_rot_matrice = require("core.3D.matrice.rotation_euler")
local quat_rot_matrice  = require("core.3D.matrice.rotation_quaternion")
local trans_matrice     = require("core.3D.matrice.translate")

local sqrt  = math.sqrt
local floor = math.floor
local sin   = math.sin
local cos   = math.cos

return {add=function(BUS)
    local function add(a,b)
        return BUS.object.vector.new(
            a[1]+b[1],
            a[2]+b[2],
            a[3]+b[3]
        )
    end
    local function subtract(a,b)
        return BUS.object.vector.new(
            a[1]-b[1],
            a[2]-b[2],
            a[3]-b[3]
        )
    end
    local function multiply(a,b)
        return BUS.object.vector.new(
            a[1]*b[1],
            a[2]*b[2],
            a[3]*b[3]
        )
    end
    local function divide(a,b)
        return BUS.object.vector.new(
            a[1]/b[1],
            a[2]/b[2],
            a[3]/b[3]
        )
    end
    local function modulo(a,b)
        return BUS.object.vector.new(
            a[1]%b[1],
            a[2]%b[2],
            a[3]%b[3]
        )
    end
    local function power(a,b)
        return BUS.object.vector.new(
            a[1]^b[1],
            a[2]^b[2],
            a[3]^b[3]
        )
    end
    local function unary(a)
        return BUS.object.vector.new(
            -a[1],-a[2],-a[3]
        )
    end
    local function lenght(a)
        local x,y,z = a[1],a[2],a[3]
        return sqrt(x*x+y*y+z*z)
    end
    local function equal(a,b)
        return  a[1] == b[1]
            and a[2] == b[2]
            and a[3] == b[3]
    end

    local function scale(v,sx,sy,sz)
        sx,sy,sz = sx and 1,sy and 1,sz and 1

        local new_x,new_y,new_z = matmul(v[1],v[2],v[3],1,scale_matrice(sx,sy,sz))

        return BUS.object.vector.new(
            new_x,new_y,new_z
        )
    end
    local function translate(v,tx,ty,tz)
        tx,ty,tz = tx or 0,ty or 0,tz or 0
        local new_x,new_y,new_z = matmul(v[1],v[2],v[3],1,trans_matrice(tx,ty,tz))

        return BUS.object.vector.new(
            new_x,new_y,new_z
        )
    end
    local function rotate(v,rx,ry,rz,w)
        local rotation
        if not w then
            rotation = euler_rot_matrice(rx,ry,rz)
        else
            rotation = quat_rot_matrice(rx,ry,rz,w)
        end
        local new_x,new_y,new_z = matmul(v[1],v[2],v[3],1,rotation)
        return BUS.object.vector.new(
            new_x,new_y,new_z
        )
    end

    local function from_pitch_yaw(pitch,yaw)
        return BUS.object.vector.new(
            -sin(yaw)*cos(pitch),
            sin(pitch),
            -cos(yaw)*cos(pitch)
        ):normalize()
    end
    local function from_yaw(yaw)
        return BUS.object.vector.new(
            -sin(yaw),
            0,
            -sin(yaw)
        ):normalize()
    end

    return function()
        local vector = plugin.new("c3d:object->vector")

        function vector.register_objects()
            local object_registry = c3d.registry.get_object_registry()
            local vector_object   = object_registry:new_entry("vector")

            vector_object:set_entry(c3d.registry.entry("normalize"),function(this)
                local lenght = #this
                return BUS.object.vector.new(
                    this[1]/lenght,
                    this[2]/lenght,
                    this[3]/lenght
                )
            end)
            vector_object:set_entry(c3d.registry.entry("dot"),function(this,other)
                return this[1]*other[1] + this[2]*other[2] + this[3]*other[3]
            end)
            vector_object:set_entry(c3d.registry.entry("cross"),function(this,other)
                return BUS.object.vector.new(
                    this[2] * other[3] - this[3] * other[2],
                    this[3] * other[1] - this[1] * other[3],
                    this[1] * other[2] - this[2] * other[1]
                )
            end)
            vector_object:set_entry(c3d.registry.entry("round"),function(this,decimals)
                local dmals = 10^(decimals or 0)
                return BUS.object.vector.new(
                    floor(this[1]*dmals+0.5)/dmals,
                    floor(this[2]*dmals+0.5)/dmals,
                    floor(this[3]*dmals+0.5)/dmals
                )
            end)

            vector_object:set_entry(c3d.registry.entry("add"),       add)
            vector_object:set_entry(c3d.registry.entry("subtract"),  subtract)
            vector_object:set_entry(c3d.registry.entry("divide"),    divide)
            vector_object:set_entry(c3d.registry.entry("get_lenght"),lenght)
            vector_object:set_entry(c3d.registry.entry("equals"),    equal)
            vector_object:set_entry(c3d.registry.entry("unm"),       unary)

            vector_object:set_entry(c3d.registry.entry("scale"),    scale)
            vector_object:set_entry(c3d.registry.entry("translate"),translate)
            vector_object:set_entry(c3d.registry.entry("rotate"),   rotate)

            vector_object:set_entry(c3d.registry.entry("from_pitch_yaw"),from_pitch_yaw)
            vector_object:set_entry(c3d.registry.entry("from_yaw"),      from_yaw)

            vector_object:set_metadata("__add",add)
            vector_object:set_metadata("__sub",subtract)
            vector_object:set_metadata("__mul",multiply)
            vector_object:set_metadata("__div",divide)
            vector_object:set_metadata("__mod",modulo)
            vector_object:set_metadata("__pow",power)
            vector_object:set_metadata("__unm",unary)
            vector_object:set_metadata("__len",lenght)
            vector_object:set_metadata("__eq",equal)
            vector_object:set_metadata("__tostring",function(this)
                return ("vector: x%f, y%f, z%f"):format(this[1],this[2],this[3])
            end)

            vector_object:constructor(function(x,y,z)
                local obj = {
                    x or 0,y or 0,z or 0
                }
        
                return obj
            end)
        end

        vector:register()
    end
end}