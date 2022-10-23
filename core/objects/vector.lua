local object = require("core.object")

local sqrt  = math.sqrt
local floor = math.floor

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

    local vector_object = {
        __index = object.new{
            normalize=function(this)
                local lenght = #this
                return BUS.object.vector.new(
                    this[1]/lenght,
                    this[2]/lenght,
                    this[3]/lenght
                ) 
            end,
            dot=function(this,other)
                return this[1]*other[1] + this[2]*other[2] +this[3]*other[3]
            end,
            cross=function(this,other)
                return BUS.object.vector.new(
                    this[2] * other[3] - other[3] * other[2],
                    this[3] * other[1] - other[1] * other[3],
                    this[1] * other[2] - other[2] * other[1]
                )
            end,
            round=function(this,decimals)
                decimals = decimals or 1
                return BUS.object.vector.new(
                    floor(this[1]*10^decimals)/decimals,
                    floor(this[2]*10^decimals)/decimals,
                    floor(this[3]*10^decimals)/decimals
                )
            end,
            add=add,
            subtract=subtract,
            divide=divide,
            get_lenght=lenght,
            equals=equal,
            unm=unary,
        },
        __add=add,
        __sub=subtract,
        __mul=multiply,
        __div=divide,
        __mod=modulo,
        __pow=power,
        __unm=unary,
        __len=lenght,
        __eq=equal,
        __tostring=function(this)
            return ("vector: x%f, y%f, z%f"):format(this[1],this[2],this[3])
        end,
    }

    return {new=function(x,y,z)

        local obj = {
            x or 0,y or 0,z or 0
        }

        return setmetatable(obj,vector_object):__build()
    end}
end}