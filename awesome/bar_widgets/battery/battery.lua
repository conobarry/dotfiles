-- Awesome libraries
local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")

local capacity_command = 'bash -c "cat /sys/class/power_supply/BAT0/capacity"'
local status_command = 'bash -c "cat /sys/class/power_supply/BAT0/status"'
local command = 'bash -c "echo $(cat /sys/class/power_supply/BAT0/capacity) $(cat /sys/class/power_supply/BAT0/status)"'

local function to_icon_path(filename)
  return beautiful.to_icon_path("bar/battery-" .. filename)
end

local battery = {
  empty_value = 5,
  caution_value = 20,
  low_value = 40,
  medium_value = 60,
  high_value = 80,
  full_value = 100,
}

battery.icons = {
  empty = to_icon_path("empty"),
  caution = to_icon_path("caution"),
  low = to_icon_path("low"),
  medium = to_icon_path("medium"),
  high = to_icon_path("high"),
  full = to_icon_path("full"),
  empty_charging = to_icon_path("empty-charging"),
  caution_charging = to_icon_path("caution-charging"),
  low_charging = to_icon_path("low-charging"),
  medium_charging = to_icon_path("medium-charging"),
  high_charging = to_icon_path("high-charging"),
  full_charging = to_icon_path("full-charging"),
  missing = to_icon_path("missing"),
}

-- battery.textbox = wibox.widget {
--   widget = wibox.widget.textbox,
--   visible = false
-- }

battery.imagebox = wibox.widget {
  widget = wibox.widget.imagebox,
  image = battery.icons.full,
  visible = true
}

battery.watch = awful.widget.watch(command, 1,
  function(widget, stdout)
    
    local capacity, status = stdout:match("(%d+)%s+(%w+)")
    capacity = tonumber(capacity)
      
    local icon_name = ""
    
    if (capacity <= battery.empty_value) then
      icon_name = "empty"
    elseif (capacity <= battery.caution_value) then
      icon_name = "caution"
    elseif (capacity <= battery.low_value) then
      icon_name = "low"
    elseif (capacity <= battery.medium_value) then
      icon_name = "medium"
    elseif (capacity <= battery.high_value) then
      icon_name = "high"
    else
      icon_name = "full"
    end
    
    if (status == "Charging") then
      icon_name = icon_name .. "_charging"
    elseif (status == "Discharging") then
    elseif (status == "Full") then
      icon_name = "full_charging"
      capacity = 100
    else
      -- icon_name = "missing"
    end
    
    widget.markup = string.format("<span font='%s' foreground='%s'>%d%%</span>", beautiful.bar.font, beautiful.bar.fg_black, capacity)
    
    battery.imagebox.image = battery.icons[icon_name]
  end
)

battery.watch.visible = false

battery.widget = wibox.widget {
  -- widget = battery.background,
  -- {
    widget = wibox.container.margin,
    left = beautiful.bar.widget_padding,
    right = beautiful.bar.widget_padding,
    {
      layout = wibox.layout.stack,
      -- {
        -- widget = wibox.container.margin,
        -- margins = beautiful.dpi(2),
        {
          widget = battery.imagebox,
        },
      -- },
      {
        widget = battery.watch,
      }
    }
  }
-- }

battery.widget:connect_signal("mouse::enter",
  function(widget)
    battery.imagebox.visible = false
    -- battery.textbox.markup = battery.markup:generate()
    battery.watch.visible = true
    -- battery.background.bg = battery.bg_focus
  end
)

battery.widget:connect_signal("mouse::leave",
  function()
    -- _volume:fetch_levels()
    battery.imagebox.visible = true
    battery.watch.visible = false
    -- battery.background.bg = battery.bg_normal
  end
)

return battery.widget