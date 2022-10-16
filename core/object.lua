local function make_methods(child)
    return setmetatable({
        __build=function(obj)
            child = obj 
            return obj
        end,
        type = function() return child.obj_type end,
    },{__tostring=function() return "object" end})
end

return {new=function(child)
    return setmetatable(child,{__index=make_methods(child)})
end}