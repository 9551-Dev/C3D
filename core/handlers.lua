return {attach=function(ENV)
    ENV.c3d.handlers = setmetatable({},
        {__index=function()
            return function()
        end
    end})
end}