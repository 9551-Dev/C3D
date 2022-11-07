local generic = require("common.generic")

local object = require("core.object")

local function is_code(input)
    local _,newlines   = input:gsub("\n","\n")
    local _,semicolons = input:gsub(";",";")
    local _,spaces     = input:gsub(" "," ")
    if newlines > 1 or semicolons > 1 or spaces > 1 or #input > 1024 then
        return true
    else return false end
end

return function(BUS)
    local objects = {
        thread={__index=object.new{
            get_error  = function(this) return this.error end,
            is_running = function(this) return coroutine.status(this.c) == "running" end,
            start      = function(this,...)
                if not this.started then
                    coroutine.resume(this.c,...)
                    this.started = true
                end
            end,
            wait = function(this)
                while coroutine.status(this.c) ~= "dead" do
                    generic.precise_sleep(0.01)
                end
            end
        },__tostring=function() return "C3D_Thread" end},
        channel={__index=object.new{
            clear  = function(this) this.queue = {} end,
            demand = function(this,timeout)
                local timed_out = math.huge
                if timeout then timed_out = os.epoch("utc") + timeout end

                while #this.queue < 1 or os.epoch("utc") > timed_out do
                    os.queueEvent("waiting")
                    os.pullEvent("waiting")
                end

                local received = table.remove(this.queue,1)
                this.push_ids[received.id] = true
                return received.value

            end,
            get_count = function(this) return #this.queue end,
            has_read  = function(this,id) return not not this.pushed_ids[id] end,
            peek      = function(this)
                local v = this.queue[1]
                if v then return v.value end
                return nil
            end,
            pop = function(this)
                local received = table.remove(this.queue,1)
                if received then
                    this.push_ids[received.id] = true
                    return received.value
                end
                return nil
            end,
            push   = function(this,value)
                local id = generic.uuid4()
                this.queue[#this.queue+1] = {value=value,id=id}
                return id
            end,
            supply = function(this,value,timeout)
                local id = generic.uuid4()
                this.queue[#this.queue+1] = {value=value,id=id}

                local timed_out = math.huge
                if timeout then timed_out = os.epoch("utc") + timeout end

                while not this.push_ids[id] or os.epoch("utc") > timed_out do
                    os.queueEvent("waiting")
                    os.pullEvent("waiting")
                end
                return not (os.epoch("utc") > timed_out)
            end
        },__tostring=function() return "c3dC_Chanel" end}
    }

    local function GET_CHANNEL(name)
        if BUS.thread.channel[name] then
            return BUS.thread.channel[name]
        else
            BUS.thread.channel[name] = setmetatable({
                queue={},
                push_ids={},

                obj_type = "Channel",
                stored_in = BUS.thread.channel,
                under = name,
                object = BUS.thread.channel[name]

            },objects.channel):__build()
            return BUS.thread.channel[name]
        end
    end

    return function()
        local thread = plugin.new("c3d:thread")

        function thread.register_modules()
            local module_registry = c3d.registry.get_module_registry()
            local thread_module   = module_registry:new_entry("thread")

            thread_module:set_entry(c3d.registry.entry("new_thread"),function(code)
                local id = generic.uuid4()

                if not is_code(code) then
                    local selected_path = fs.combine(BUS.instance.scenedir,code)
                    local file,reason = fs.open(selected_path,"r")
                    if file then
                        code = file.readAll()
                    else return false,reason end
                end

                local func,msg = load(code or "","Thread error","t",BUS.ENV)

                if func then

                    BUS.thread.coro[id] = setmetatable({
                        c = coroutine.create(function(...)
                            coroutine.yield()
                            func(...)
                        end),
                        started=false,

                        obj_type="Thread",
                        stored_in=BUS.thread.coro,
                        under=id,
                        object=BUS.thread.coro[id]
                    },objects.thread):__build()

                    return BUS.thread.coro[id]
                else return false,msg end
            end)

            thread_module:set_entry(c3d.registry.entry("new_channel"),function()
                local id = generic.uuid4()
                return GET_CHANNEL(id)
            end)

            thread_module:set_entry(c3d.registry.entry("get_channel"),function(name)
                return GET_CHANNEL(name)
            end)
        end

        thread:register()
    end
end
