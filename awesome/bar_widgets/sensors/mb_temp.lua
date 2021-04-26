-- Awesome libraries
local awful = require("awful")
local beautiful = require("beautiful")

local command = 'bash -c "sensors | grep \'MB Temp\' | awk \'{print substr($3, 2, length($3)-5)}\'"'

local mb_temp = awful.widget.watch(command, 2,
  function(widget, stdout)
    widget.markup = string.format("<span font='%s' foreground='%s'>%3d</span>", beautiful.bar.font, beautiful.bar.fg_white, stdout)
  end
)

return mb_temp