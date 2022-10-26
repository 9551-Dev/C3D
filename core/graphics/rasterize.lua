local CEIL,MAX,MIN,pairs = math.ceil,math.max,math.min,pairs

local int_y  = require("core.3D.math.interpolate_y")
local get_t  = require("core.3D.math.get_interpolant")
local int_uv = require("core.3D.math.interpolate_uv")

local bary_c     = require("core.3D.geometry.bary_coords")
local int_vertex = require("core.3D.geometry.interpolate_vertex")

return {build=function(BUS)
    local graphics_bus = BUS.graphics

    local function draw_flat_top_triangle(fs,object,v0,v1,v2,tex,origin,fragment,w,h)
        local v0x,v0y = v0[1],v0[2]
        local v1x,v1y = v1[1],v1[2]
        local v2x,v2y = v2[1],v2[2]
        local o1,o2,o3 = origin[1],origin[2],origin[3]
        local o1frag,o2frag,o3frag = o1.frag,o2.frag,o3.frag
        local o13,o14  = o1[3],o1[4]
        local m0 = (v2x - v0x) / (v2y - v0y)
        local m1 = (v2x - v1x) / (v2y - v1y)
        local y_start = MAX(CEIL(v0y - 0.5),1)
        local y_end   = MIN(CEIL(v2y - 0.5)-1,h)

        local C = object.color
        local TPIX = (tex or {}).pixels
    
        for y=y_start,y_end do
            local px0 = m0 * (y + 0.5 - v0y) + v0x
            local px1 = m1 * (y + 0.5 - v1y) + v1x
            local x_start = MAX(CEIL(px0 - 0.5),1)
            local x_end   = MIN(CEIL(px1 - 0.5),w)
    
            local sx_start = int_y(o1,o2,y)
            local sx_end   = int_y(o1,o3,y)
            local t1 = get_t(o1,o2,sx_start,y)
            local t2 = get_t(o1,o3,sx_end,y)
            local w1 = (1 - t1) * o13 + t1 * o2[3]
            local w2 = (1 - t2) * o13 + t2 * o3[3]
            local z1 = (1 - t1) * o14 + t1 * o2[4]
            local z2 = (1 - t2) * o14 + t2 * o3[4]

            local temp_interpolants1 = {}
            local temp_interpolants2 = {}
            local naming = {}
            local num = 0
            if o1frag then for k,v in pairs(o1frag) do
                if o2frag[k] and o3frag[k] then
                    num = num + 1
                    temp_interpolants1[k] = (1 - t1) * v + t1 * o2frag[k]
                    temp_interpolants2[k] = (1 - t2) * v + t2 * o3frag[k]
                    naming[num] = k
                end
            end end
    
            for x=x_start,x_end do
                local bary = bary_c(x,y,v0,v1,v2)
    
                local div = sx_end - sx_start
                local t3 = (x - sx_start) / ((div == 0) and 5e-10 or div)
    
                local z = 1/((1 - t3) * w1 + t3 * w2)
    
                local frag_data = {
                    texture = TPIX,
                    tex=tex,
                    color = C,
                    x=x,y=y,
                    z_correct=z
                }
                for i=1,num do
                    local nm = naming[i]
                    frag_data[nm] = ((1 - t3) * temp_interpolants1[nm] + t3 * temp_interpolants2[nm])*z
                end

                if tex then
                    local tpos = int_uv(bary,v0,v1,v2)
                    frag_data.tx = MAX(1,MIN(CEIL(tpos[1]*z*tex.w),tex.w))
                    frag_data.ty = MAX(1,MIN(CEIL(tpos[2]*z*tex.h),tex.h))
                    frag_data.tx,frag_data.ty = tpos[1],tpos[2]
                end
    
                fragment(x,y,(1 - t3) * z1 + t3 * z2,
                    fs(frag_data)
                )
            end
        end
    end
    
    local function draw_flat_bottom_triangle(fs,object,v0,v1,v2,tex,origin,fragment,w,h)
        local v0x,v0y = v0[1],v0[2]
        local v1x,v1y = v1[1],v1[2]
        local v2x,v2y = v2[1],v2[2]
        local o1,o2,o3 = origin[1],origin[2],origin[3]
        local o1frag,o2frag,o3frag = o1.frag,o2.frag,o3.frag
        local o13,o14  = o1[3],o1[4]
        local m0 = (v1x - v0x) / (v1y - v0y)
        local m1 = (v2x - v0x) / (v2y - v0y)
        local y_start = MAX(CEIL(v0y - 0.5),1)
        local y_end   = MIN(CEIL(v2y - 0.5)-1,h)

        local C = object.color
        local TPIX = (tex or {}).pixels
    
        for y=y_start,y_end do
            local px0 = m0 * (y + 0.5 - v0y) + v0x
            local px1 = m1 * (y + 0.5 - v0y) + v0x
            local x_start = MAX(CEIL(px0 - 0.5),1)
            local x_end   = MIN(CEIL(px1 - 0.5),w)
    
            local sx_start = int_y(o1,o2,y)
            local sx_end   = int_y(o1,o3,y)
            local t1 = get_t(o1,o2,sx_start,y)
            local t2 = get_t(o1,o3,sx_end,y)
            local w1 = (1 - t1) * o13 + t1 * o2[3]
            local w2 = (1 - t2) * o13 + t2 * o3[3]
            local z1 = (1 - t1) * o14 + t1 * o2[4]
            local z2 = (1 - t2) * o14 + t2 * o3[4]

            local temp_interpolants1 = {}
            local temp_interpolants2 = {}
            local naming = {}
            local num = 0
            if o1frag then for k,v in pairs(o1frag) do
                if o2frag[k] and o3frag[k] then
                    num = num + 1
                    temp_interpolants1[k] = (1 - t1) * v + t1 * o2frag[k]
                    temp_interpolants2[k] = (1 - t2) * v + t2 * o3frag[k]
                    naming[num] = k
                end
            end end
    
            for x=x_start,x_end do
                local bary =  bary_c(x,y,v0,v1,v2)
    
                local div = sx_end - sx_start
                local t3 = (x - sx_start) / ((div == 0) and 5e-10 or div)
    
                local z = 1/((1 - t3) * w1 + t3 * w2)
    
                local frag_data = {
                    texture = TPIX,
                    tex=tex,
                    color = C,
                    x=x,y=y,
                    z_correct=z
                }
                for i=1,num do
                    local nm = naming[i]
                    frag_data[nm] = ((1 - t3) * temp_interpolants1[nm] + t3 * temp_interpolants2[nm])*z
                end

                if tex then
                    local tpos = int_uv(bary,v0,v1,v2)
                    frag_data.tx = MAX(1,MIN(CEIL(tpos[1]*z*tex.w),tex.w))
                    frag_data.ty = MAX(1,MIN(CEIL(tpos[2]*z*tex.h),tex.h))
                    frag_data.tx,frag_data.ty = tpos[1],tpos[2]
                end
    
                fragment(x,y,(1 - t3) * z1 + t3 * z2,
                    fs(frag_data)
                )
            end
        end
    end
    return {triangle=function(fs,object,p1,p2,p3,tex,frag)
        local w,h = graphics_bus.w,graphics_bus.h
        local ori = {p1,p2,p3}
        if p2[2] < p1[2] then p1,p2 = p2,p1 end
        if p3[2] < p2[2] then p2,p3 = p3,p2 end
        if p2[2] < p1[2] then p1,p2 = p2,p1 end
        if p1[2] == p2[2] then
            if p2[1] < p1[1] then p1,p2 = p2,p1 end
            draw_flat_top_triangle(fs,object,p1,p2,p3,tex,ori,frag,w,h)
        elseif p2[2] == p3[2] then
            if p3[1] < p2[1] then p2,p3 = p3,p2 end
            draw_flat_bottom_triangle(fs,object,p1,p2,p3,tex,ori,frag,w,h)
        else
            local alpha_split = (p2[2]-p1[2]) / (p3[2]-p1[2])
            local split_vertex = int_vertex(p1,p3,alpha_split)
            
            if p2[1] < split_vertex[1] then
                draw_flat_bottom_triangle(fs,object,p1,p2,split_vertex,tex,ori,frag,w,h)
                draw_flat_top_triangle   (fs,object,p2,split_vertex,p3,tex,ori,frag,w,h)
            else
                draw_flat_bottom_triangle(fs,object,p1,split_vertex,p2,tex,ori,frag,w,h)
                draw_flat_top_triangle   (fs,object,split_vertex,p2,p3,tex,ori,frag,w,h)
            end
        end
    end}
end}