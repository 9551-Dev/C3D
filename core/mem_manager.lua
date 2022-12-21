return {get=function(BUS)
    local methods = {}

    local memory = BUS.mem

    function methods.init_category(cat)
        memory[cat] = {n=0}
    end

    function methods.get_table(cat)
        local memory = memory

        local mem_category = memory[cat]
        local n = mem_category.n+1
        mem_category.n = n
        if not mem_category[n] then mem_category[n] = {} end
        return mem_category[n]
    end

    for i=1,3 do methods.init_category(i) end

    return methods
end}