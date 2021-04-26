-- Awesome libraries
local wibox = require("wibox")
local beautiful = require('beautiful')

local systray = wibox.widget
{
  widget = wibox.container.background,
  bg = beautiful.bar.bg_normal,
  {
    widget = wibox.container.margin,
    margins = beautiful.bar.icon_padding,
    {
      widget = wibox.widget.systray,
      opacity = 1
    }
  }
}

return systray