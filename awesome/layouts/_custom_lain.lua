--[[

     Licensed under GNU General Public License v2
      * (c) 2014,      projektile
      * (c) 2013,      Luca CPZ
      * (c) 2010,      Nicolas Estibals
      * (c) 2010-2012, Peter Hofmann

--]]

local math     = math
local screen   = screen
local tonumber = tonumber

local custom  = { name = "termfair" }
custom.center = { name = "centerfair" }
custom.stable = { name = "stablefair" }

local function do_fair(p, orientation)
    local tag = p.tag or screen[p.screen].selected_tag
    local workarea = p.workarea
    local clients = p.clients

    if #clients == 0 then return end

    -- How many vertical columns? Read from nmaster on the tag.

    -- num_x is the number of columns
    local num_x = tonumber(custom.nmaster) or tag.master_count    
    if num_x <= 2 then num_x = 2 end

    -- ncol is the number of rows
    local ncol  = tonumber(custom.ncol) or tag.column_count
    if ncol  <= 1 then ncol  = 1 end
    local width = math.floor(workarea.width/num_x)

    if orientation == "west" then
        -- Layout with fixed number of vertical columns (read from nmaster).
        -- New windows align from left to right. When a row is full, a new
        -- one above it is created. Like this:

        --        (1)                (2)                (3)
        --   +---+---+---+      +---+---+---+      +---+---+---+
        --   |   |   |   |      |   |   |   |      |   |   |   |
        --   | 1 |   |   |  ->  | 1 | 2 |   |  ->  | 1 | 2 | 3 |  ->
        --   |   |   |   |      |   |   |   |      |   |   |   |
        --   +---+---+---+      +---+---+---+      +---+---+---+

        --        (4)                (5)                (6)
        --   +---+---+---+      +---+---+---+      +---+---+---+
        --   | 1 |   |   |      | 1 | 2 |   |      | 1 | 2 | 3 |
        --   +---+---+---+  ->  +---+---+---+  ->  +---+---+---+
        --   | 2 | 3 | 4 |      | 3 | 4 | 5 |      | 4 | 5 | 6 |
        --   +---+---+---+      +---+---+---+      +---+---+---+

        local num_y     = math.max(math.ceil(#clients / num_x), ncol)
        local height    = math.floor(workarea.height/num_y)
        local cur_num_x = num_x
        local at_x      = 0
        local at_y      = 0

        local remaining_clients = #clients

        -- We start the first row. Left-align by limiting the number of
        -- available slots.
        if remaining_clients < num_x then
            cur_num_x = remaining_clients
        end

        -- Iterate in reversed order.
        for i = #clients,1,-1 do
            -- Get x and y position.
            local c = clients[i]
            local this_x = cur_num_x - at_x - 1
            local this_y = num_y - at_y - 1

            -- Calculate geometry.
            local g = {}
            if this_x == (num_x - 1) then
                g.width = workarea.width - (num_x - 1)*width
            else
                g.width = width
            end

            if this_y == (num_y - 1) then
                g.height = workarea.height - (num_y - 1)*height
            else
                g.height = height
            end

            g.x = workarea.x + this_x*width
            g.y = workarea.y + this_y*height

            if g.width  < 1 then g.width  = 1 end
            if g.height < 1 then g.height = 1 end

            p.geometries[c] = g

            remaining_clients = remaining_clients - 1

            -- Next grid position.
            at_x = at_x + 1
            if at_x == num_x then
                -- Row full, create a new one above it.
                at_x = 0
                at_y = at_y + 1

                -- We start a new row. Left-align.
                if remaining_clients < num_x then
                    cur_num_x = remaining_clients
                end
            end
        end
    elseif orientation == "stable" then
        -- Layout with fixed number of vertical columns (read from nmaster).
        -- New windows align from left to right. When a row is full, a new
        -- one below it is created. Like this:

        --        (1)                (2)                (3)
        --   +---+---+---+      +---+---+---+      +---+---+---+
        --   |   |   |   |      |   |   |   |      |   |   |   |
        --   | 1 |   |   |  ->  | 1 | 2 |   |  ->  | 1 | 2 | 3 |  ->
        --   |   |   |   |      |   |   |   |      |   |   |   |
        --   +---+---+---+      +---+---+---+      +---+---+---+

        --        (4)                (5)                (6)
        --   +---+---+---+      +---+---+---+      +---+---+---+
        --   | 1 | 2 | 3 |      | 1 | 2 | 3 |      | 1 | 2 | 3 |
        --   +---+---+---+      +---+---+---+      +---+---+---+
        --   | 4 |   |   |      | 4 | 5 |   |      | 4 | 5 | 6 |
        --   +---+---+---+  ->  +---+---+---+  ->  +---+---+---+

        local num_y     = math.max(math.ceil(#clients / num_x), ncol)
        local height    = math.floor(workarea.height/num_y)

        for i = #clients,1,-1 do
            -- Get x and y position.
            local c = clients[i]
            local this_x = (i - 1) % num_x
            local this_y = math.floor((i - this_x - 1) / num_x)

            -- Calculate geometry.
            local g = {}
            if this_x == (num_x - 1) then
                g.width = workarea.width - (num_x - 1)*width
            else
                g.width = width
            end

            if this_y == (num_y - 1) then
                g.height = workarea.height - (num_y - 1)*height
            else
                g.height = height
            end

            g.x = workarea.x + this_x*width
            g.y = workarea.y + this_y*height

            if g.width  < 1 then g.width  = 1 end
            if g.height < 1 then g.height = 1 end

            p.geometries[c] = g
        end
    elseif orientation == "center" then
        -- Layout with fixed number of vertical columns (read from nmaster).
        -- Cols are centerded until there is nmaster columns, then windows
        -- are stacked in the slave columns, with at most ncol clients per
        -- column if possible.

        -- with nmaster=3 and ncol=1 you'll have
        --        (1)                (2)                (3)
        --   +---+---+---+      +-+---+---+-+      +---+---+---+
        --   |   |   |   |      | |   |   | |      |   |   |   |
        --   |   | 1 |   |  ->  | | 1 | 2 | | ->   | 1 | 2 | 3 |  ->
        --   |   |   |   |      | |   |   | |      |   |   |   |
        --   +---+---+---+      +-+---+---+-+      +---+---+---+

        --        (4)                (5)
        --   +---+---+---+      +---+---+---+
        --   |   |   | 3 |      |   | 2 | 4 |
        --   + 1 + 2 +---+  ->  + 1 +---+---+
        --   |   |   | 4 |      |   | 3 | 5 |
        --   +---+---+---+      +---+---+---+

        if #clients < num_x then

            -- Less clients than the number of columns, let's center it!
            local offset_x = workarea.x + (workarea.width - #clients*width) / 2

            for i = 1, #clients do
                local geometry = { y = workarea.y }

                geometry.width  = width
                geometry.height = workarea.height

                if geometry.width < 1 then geometry.width = 1 end
                if geometry.height < 1 then geometry.height = 1 end
                
                geometry.x = offset_x + (i - 1) * width
                p.geometries[clients[i]] = geometry
            end
        else
            -- More clients than the number of columns, let's arrange it!
            -- Master client deserves a special treatement
            local g = {}
            g.width = workarea.width - (num_x - 1)*width
            g.height = workarea.height
            if g.width < 1 then g.width = 1 end
            if g.height < 1 then g.height = 1 end
            g.x = workarea.x
            g.y = workarea.y
            p.geometries[clients[1]] = g

            -- Treat the other clients

            -- Compute distribution of clients among columns
            local num_y = {}
            local remaining_clients = #clients-1
            local ncol_min = math.ceil(remaining_clients/(num_x-1))

            if ncol >= ncol_min then
                for i = (num_x-1), 1, -1 do
                    if (remaining_clients-i+1) < ncol then
                        num_y[i] = remaining_clients-i + 1
                    else
                        num_y[i] = ncol
                    end
                    remaining_clients = remaining_clients - num_y[i]
                end
            else
                local rem = remaining_clients % (num_x-1)
                if rem == 0 then
                    for i = 1, num_x-1 do
                        num_y[i] = ncol_min
                    end
                else
                    for i = 1, num_x-1 do
                        num_y[i] = ncol_min - 1
                    end
                    for i = 0, rem-1 do
                        num_y[num_x-1-i] = num_y[num_x-1-i] + 1
                    end
                end
            end

            -- Compute geometry of the other clients
            local nclient = 2 -- we start with the 2nd client
            local wx = g.x + g.width
            for i = 1, (num_x-1) do
                local height = math.floor(workarea.height / num_y[i])
                local wy = workarea.y
                for _ = 0, (num_y[i]-2) do
                    g = {}
                    g.x = wx
                    g.y = wy
                    g.height = height
                    g.width = width
                    if g.width < 1 then g.width = 1 end
                    if g.height < 1 then g.height = 1 end
                    p.geometries[clients[nclient]] = g
                    nclient = nclient + 1
                    wy = wy + height
                end
                g = {}
                g.x = wx
                g.y = wy
                g.height = workarea.height - (num_y[i] - 1)*height
                g.width = width
                if g.width < 1 then g.width = 1 end
                if g.height < 1 then g.height = 1 end
                p.geometries[clients[nclient]] = g
                nclient = nclient + 1
                wx = wx + width
            end
        end
    end
end

function custom.center.arrange(p)
    return do_fair(p, "center")
end

function custom.stable.arrange(p)
    return do_fair(p, "stable")
end

function custom.arrange(p)
    --return do_fair(p, "west")
    return do_fair(p, "center")
end

return custom
