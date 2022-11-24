return {get=function(BUS)
    local methods = {}

    local memory = BUS.mem

    function methods.get_table()
        local memory,BUS = memory,BUS

        local n = BUS.m_n
        BUS.m_n = n + 1

        if not memory[n] then memory[n] = {} end
        return memory[n]
    end

    return methods
end}