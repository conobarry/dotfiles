-- Awesome libraries
local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")

-- local capacity_command = 'bash -c "cat /sys/class/power_supply/BAT0/capacity"'
-- local status_command = 'bash -c "cat /sys/class/power_supply/BAT0/status"'
-- local command = 'bash -c "echo $(cat /sys/class/power_supply/BAT0/capacity) $(cat /sys/class/power_supply/BAT0/status)"'

local device_name = "enp34s0"
local command = string.format('bash -c "echo $(nmcli device | awk \'/%s/ {print($1, $2, $3)}\')"', device_name)



local function to_icon_path(filename)
  return beautiful.to_icon_path("bar/network-" .. filename)
end

local network = {
  empty_value = 5,
  caution_value = 20,
  low_value = 40,
  medium_value = 60,
  high_value = 80,
  full_value = 100,
}

network.icons = {
  wired = to_icon_path("wired"),
  wired_acquiring = to_icon_path("wired-acquiring"),
  wired_no_route = to_icon_path("wired-no-route"),
  wired_offline = to_icon_path("wired-offline"),
}

network.imagebox = wibox.widget {
  widget = wibox.widget.imagebox,
  image = nil, --network.icons.wired_no_route,
  visible = true
}

network.watch = awful.widget.watch(command, 1,
  function(widget, stdout)
    
    local device, conn_type, state = stdout:match("(%w+)%s+(%w+)%s+(%w+)")
    -- capacity = tonumber(capacity)
      
    local icon_name = ""
    
    if (state == "connected") then
      icon_name = "wired"
    elseif (state == "disconnected") then
      icon_name = "wired_offline"
    elseif (state == "connecting") then
      icon_name = "wired_acquiring"
    end

    -- if (capacity <= network.empty_value) then
    --   icon_name = "empty"
    -- elseif (capacity <= network.caution_value) then
    --   icon_name = "caution"
    -- elseif (capacity <= network.low_value) then
    --   icon_name = "low"
    -- elseif (capacity <= network.medium_value) then
    --   icon_name = "medium"
    -- elseif (capacity <= network.high_value) then
    --   icon_name = "high"
    -- else
    --   icon_name = "full"
    -- end
    
    -- if (status == "Charging") then
    --   icon_name = icon_name .. "_charging"
    -- elseif (status == "Discharging") then
    -- elseif (status == "Full") then
    --   icon_name = "full_charging"
    --   capacity = 100
    -- else
    --   -- icon_name = "missing"
    -- end
    
    -- widget.markup = string.format("<span font='%s' foreground='%s'>%d%%</span>", beautiful.bar.font, beautiful.bar.fg_black, capacity)
    
    network.imagebox.image = network.icons[icon_name]
  end
)

network.watch.visible = false

network.widget = wibox.widget {
  -- widget = battery.background,
  -- {
    widget = wibox.container.margin,
    left = beautiful.bar.widget_padding,
    right = beautiful.bar.widget_padding,
    {
      -- layout = wibox.layout.stack,
      -- {
        -- widget = wibox.container.margin,
        -- margins = beautiful.dpi(2),
        -- {
          widget = network.imagebox,
        -- },
      -- },
      -- {
      --   widget = network.watch,
      -- }
    }
  }
-- }

-- network.widget:connect_signal("mouse::enter",
--   function(widget)
--     network.imagebox.visible = false
--     -- battery.textbox.markup = battery.markup:generate()
--     network.watch.visible = true
--     -- battery.background.bg = battery.bg_focus
--   end
-- )

-- network.widget:connect_signal("mouse::leave",
--   function()
--     -- _volume:fetch_levels()
--     network.imagebox.visible = true
--     network.watch.visible = false
--     -- battery.background.bg = battery.bg_normal
--   end
-- )

return network.widget