-- Awesome libraries
local wibox = require("wibox")
local beautiful = require('beautiful')

-- Adds the font to the time format
local function get_format(time_format)
  return string.format("<span font='%s'>%s</span>", beautiful.bar.font, time_format)
end

local long_format = get_format("%H:%M:%S")
local short_format = get_format("%H:%M")

local textclock = wibox.widget.textclock(short_format, 1)

-- Create a textclock widget
-- The time format is built in to lua: http://www.lua.org/pil/22.1.html
local time = wibox.widget
{
  -- widget = wibox.container.margin,
  -- color = "#000000",
  -- margins = 1,
  -- {
    widget = wibox.container.background,
    --bg = beautiful.bg_normal,
    {
      widget = wibox.container.margin,
      margins = beautiful.bar.padding,
      {
        widget = textclock
      }
    }
  -- }
}

time:connect_signal("mouse::enter", 
  function()
    textclock.format = long_format
  end
)

time:connect_signal("mouse::leave",
  function()
    textclock.format = short_format
  end
)

return time