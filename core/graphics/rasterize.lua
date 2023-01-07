local CEIL,FLOOR,MAX,MIN,ABS,SQRT,NEXT = math.ceil,math.floor,math.max,math.min,math.abs,math.sqrt,next

local interpolate_uv = require("core.3D.math.interpolate_uv")

local barycentric_coordinates = require("core.3D.geometry.bary_coords")
local interpolate_vertex_init = require("core.3D.geometry.interpolate_vertex")

local memory_manager = require("core.mem_manager")

local empty_table = {}

local FRAGMENT_DATA = {}

return {build=function(BUS)

    BUS.log("  - Inicialized triangle rasterizer",BUS.log.info)

    local graphics_bus = BUS.graphics

    local memory_handle = memory_manager.get(BUS)

    local interpolate_vertex = interpolate_vertex_init.init(BUS)

    local function render_flat_top_triangle(v1,v2,v3,triangle_data,screen_fragment,w,h,a,b,c)
        local v1x,v1y = v1[1],v1[2]
        local v2x,v2y = v2[1],v2[2]
        local v3x,v3y = v3[1],v3[2]

        local v1u,v1v = v1[5],v1[6]
        local v2u,v2v = v2[5],v2[6]
        local v3u,v3v = v3[5],v3[6]
        local frag1,frag2,frag3 = v1.frag,v2.frag,v3.frag

        local m0 = (v3x - v1x) / (v3y - v1y)
        local m1 = (v3x - v2x) / (v3y - v2y)
        local y_start = MAX(FLOOR(v1y + 0.5),1)
        local y_end   = MIN(CEIL (v3y - 0.5)-1,h)

        local fragment_shader_data = FRAGMENT_DATA
        
        local object = triangle_data.object

        local texture         = triangle_data.texture
        local fragment_shader = triangle_data.fs

        local tex_width  = texture.w
        local tex_height = texture.h
        fragment_shader_data.color   = object.color
        fragment_shader_data.texture = (texture or empty_table).pixels
        fragment_shader_data.tex     =  texture
        local STNF = object.instantiate_fragment

        fragment_shader_data.v1 = a
        fragment_shader_data.v2 = b
        fragment_shader_data.v3 = c

        local fragment_shader_values_1 = memory_handle.get_table(2)
        local fragment_shader_values_2 = memory_handle.get_table(2)
        local fragment_shader_values_3 = memory_handle.get_table(2)
        local fragment_shader_names    = memory_handle.get_table(2)

        local fragment_count = 0
        for k,v in NEXT,frag1 do
            local f2,f3 = frag2[k],frag3[k]

            if f2 and f3 then
                fragment_count = fragment_count + 1

                fragment_shader_values_1[fragment_count] = v
                fragment_shader_values_2[fragment_count] = f2
                fragment_shader_values_3[fragment_count] = f3

                fragment_shader_names[fragment_count] = k
            end
        end

        for y=y_start,y_end do
            local px0 = m0 * (y + 0.5 - v1y) + v1x
            local px1 = m1 * (y + 0.5 - v2y) + v2x
            local x_start = MAX(CEIL(px0 - 0.5),1)
            local x_end   = MIN(CEIL(px1 - 0.5),w)

            for x=x_start,x_end do
                local bary_a,bary_b,bary_c = barycentric_coordinates(x,y,v1x,v1y,v2x,v2y,v3x,v3y)

                local z = 1/(v1[3]*bary_a+v2[3]*bary_b+v3[3]*bary_c)

                local instantiated_fragment = STNF and memory_handle.get_table(3) or triangle_data
                fragment_shader_data.x         = x
                fragment_shader_data.y         = y
                fragment_shader_data.z_correct = z
                fragment_shader_data.instance = instantiated_fragment


                local frag_data
                if fragment_count > 0 then frag_data = memory_handle.get_table(2) end
                for i=1,fragment_count do
                    frag_data[fragment_shader_names[i]] =
                        fragment_shader_values_1[i]*bary_a +
                        fragment_shader_values_2[i]*bary_b +
                        fragment_shader_values_3[i]*bary_c
                end
                fragment_shader_data.data = frag_data

                if texture then
                    local thisu,thisv = interpolate_uv(bary_a,bary_b,bary_c,v1u,v1v,v2u,v2v,v3u,v3v)
                    fragment_shader_data.tx,fragment_shader_data.ty = thisu,thisv

                    local bary_aright,bary_bright,bary_cright = barycentric_coordinates(x+1  ,y,v1x,v1y,v2x,v2y,v3x,v3y)
                    local bary_adown,bary_bdown,bary_cdown    = barycentric_coordinates(x,y+1,v1x,v1y,v2x,v2y,v3x,v3y)

                    local uright,vright = interpolate_uv(bary_aright,bary_bright,bary_cright,v1u,v1v,v2u,v2v,v3u,v3v)
                    local udown ,vdown  = interpolate_uv(bary_adown,bary_bdown,bary_cdown,v1u,v1v,v2u,v2v,v3u,v3v)

                    local L = MAX(
                        SQRT((ABS(thisu-uright)*tex_width)^2 +(ABS(thisv-vright)*tex_height)^2),
                        SQRT((ABS(thisv-vdown) *tex_height)^2+(ABS(thisu-udown) *tex_width)^2)
                    )

                    fragment_shader_data.mipmap_level = L
                else
                    fragment_shader_data.mipmap_level = 1
                    fragment_shader_data.tx,fragment_shader_data.ty = 0,0
                end

                screen_fragment(x,y,v1[4]*bary_a+v2[4]*bary_b+v3[4]*bary_c,
                    fragment_shader(fragment_shader_data)
                )
            end
        end
    end

    local function render_flat_bottom_triangle(v1,v2,v3,triangle_data,screen_fragment,w,h,a,b,c)
        local v1x,v1y = v1[1],v1[2]
        local v2x,v2y = v2[1],v2[2]
        local v3x,v3y = v3[1],v3[2]

        local v1u,v1v = v1[5],v1[6]
        local v2u,v2v = v2[5],v2[6]
        local v3u,v3v = v3[5],v3[6]
        local frag1,frag2,frag3 = v1.frag,v2.frag,v3.frag

        local m0 = (v2x - v1x) / (v2y - v1y)
        local m1 = (v3x - v1x) / (v3y - v1y)
        local y_start = MAX(FLOOR(v1y + 0.5),1)
        local y_end   = MIN(FLOOR(v3y + 0.5)-1,h)

        local fragment_shader_data = FRAGMENT_DATA
        
        local object = triangle_data.object

        local texture         = triangle_data.texture
        local fragment_shader = triangle_data.fs

        local tex_width  = texture.w
        local tex_height = texture.h
        fragment_shader_data.color   = object.color
        fragment_shader_data.texture = (texture or empty_table).pixels
        fragment_shader_data.tex     =  texture
        local STNF = object.instantiate_fragment

        fragment_shader_data.v1 = a
        fragment_shader_data.v2 = b
        fragment_shader_data.v3 = c

        local fragment_shader_values_1 = memory_handle.get_table(2)
        local fragment_shader_values_2 = memory_handle.get_table(2)
        local fragment_shader_values_3 = memory_handle.get_table(2)
        local fragment_shader_names    = memory_handle.get_table(2)

        local fragment_count = 0
        for k,v in NEXT,frag1 do
            local f2,f3 = frag2[k],frag3[k]

            if f2 and f3 then
                fragment_count = fragment_count + 1

                fragment_shader_values_1[fragment_count] = v
                fragment_shader_values_2[fragment_count] = f2
                fragment_shader_values_3[fragment_count] = f3

                fragment_shader_names[fragment_count] = k
            end
        end


        for y=y_start,y_end do
            local px0 = m0 * (y + 0.5 - v1y) + v1x
            local px1 = m1 * (y + 0.5 - v1y) + v1x
            local x_start = MAX(CEIL(px0 - 0.5),1)
            local x_end   = MIN(CEIL(px1 - 0.5),w)

            for x=x_start,x_end do
                local bary_a,bary_b,bary_c =  barycentric_coordinates(x,y,v1x,v1y,v2x,v2y,v3x,v3y)

                local z = 1/(v1[3]*bary_a+v2[3]*bary_b+v3[3]*bary_c)

                local instantiated_fragment = STNF and memory_handle.get_table(3) or triangle_data
                fragment_shader_data.x         = x
                fragment_shader_data.y         = y
                fragment_shader_data.z_correct = z
                fragment_shader_data.instance = instantiated_fragment

                local frag_data
                if fragment_count > 0 then frag_data = memory_handle.get_table(2) end
                for i=1,fragment_count do
                    frag_data[fragment_shader_names[i]] =
                        fragment_shader_values_1[i]*bary_a +
                        fragment_shader_values_2[i]*bary_b +
                        fragment_shader_values_3[i]*bary_c
                end
                fragment_shader_data.data = frag_data

                if texture then
                    local thisu,thisv = interpolate_uv(bary_a,bary_b,bary_c,v1u,v1v,v2u,v2v,v3u,v3v)
                    fragment_shader_data.tx,fragment_shader_data.ty = thisu,thisv

                    local bary_aright,bary_bright,bary_cright = barycentric_coordinates(x+1  ,y,v1x,v1y,v2x,v2y,v3x,v3y)
                    local bary_adown,bary_bdown,bary_cdown    = barycentric_coordinates(x,y+1,v1x,v1y,v2x,v2y,v3x,v3y)

                    local uright,vright = interpolate_uv(bary_aright,bary_bright,bary_cright,v1u,v1v,v2u,v2v,v3u,v3v)
                    local udown ,vdown  = interpolate_uv(bary_adown,bary_bdown,bary_cdown,v1u,v1v,v2u,v2v,v3u,v3v)

                    local L = MAX(
                        SQRT((ABS(thisu-uright)*tex_width)^2 +(ABS(thisv-vright)*tex_height)^2),
                        SQRT((ABS(thisv-vdown) *tex_height)^2+(ABS(thisu-udown) *tex_width)^2)
                    )

                    fragment_shader_data.mipmap_level = L
                else
                    fragment_shader_data.mipmap_level = 1
                    fragment_shader_data.tx,fragment_shader_data.ty = 0,0
                end

                screen_fragment(x,y,v1[4]*bary_a+v2[4]*bary_b+v3[4]*bary_c,
                    fragment_shader(fragment_shader_data)
                )
            end
        end
    end
    return {triangle=function(triangle,p1,p2,p3,pixel_size,pixel_setter,stv1,stv2,stv3)
        local width,height   = graphics_bus.w/pixel_size,graphics_bus.h/pixel_size
        if p1[2] > p3[2] then p1,p3 = p3,p1 end
        if p1[2] > p2[2] then p1,p2 = p2,p1 end
        if p2[2] > p3[2] then p2,p3 = p3,p2 end
        if p1[2] == p2[2] then
            if p2[1] < p1[1] then p1,p2 = p2,p1 end
            render_flat_top_triangle(p1,p2,p3,triangle,pixel_setter,width,height,stv1,stv2,stv3)
        elseif p2[2] == p3[2] then
            if p3[1] < p2[1] then p2,p3 = p3,p2 end
            render_flat_bottom_triangle(p1,p2,p3,triangle,pixel_setter,width,height,stv1,stv2,stv3)
        else
            local alpha_split  = (p2[2]-p1[2]) / (p3[2]-p1[2])
            local split_vertex = interpolate_vertex(p1,p3,alpha_split)

            if p2[1] < split_vertex[1] then
                render_flat_bottom_triangle(p1,p2,split_vertex,triangle,pixel_setter,width,height,stv1,stv2,stv3)
                render_flat_top_triangle   (p2,split_vertex,p3,triangle,pixel_setter,width,height,stv1,stv2,stv3)
            else
                render_flat_bottom_triangle(p1,split_vertex,p2,triangle,pixel_setter,width,height,stv1,stv2,stv3)
                render_flat_top_triangle   (split_vertex,p2,p3,triangle,pixel_setter,width,height,stv1,stv2,stv3)
            end
        end
    end}
end}
