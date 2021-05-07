-- Awesome libraries
local awful = require("awful")
local beautiful = require("beautiful")

local command = 'bash -c "sensors \'k10temp-*\' | awk \'/cpu/ {print substr($2, 2, length($2)-5)}\'"'

local cpu_temp = awful.widget.watch(command, 2,
  function(widget, stdout)
    widget.markup = string.format("<span font='%s' foreground='%s'>%2d°C</span>", beautiful.bar.font, beautiful.bar.fg_white, stdout)
  end
)

return cpu_temp