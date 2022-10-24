return function(object,prev,geo,prop,efx,out,BUS)
    local shader = efx.gs

    local output_triangles = {}
    local n = 0

    if not shader then
        return prev
    end

    local dat = prev or out.tris

    for i=1,#dat do
        local t = dat[i]
        local new = shader(t,t.index)
        if new then
            n = n + 1
            output_triangles[n] = new
        end
    end

    out.tris = output_triangles
end