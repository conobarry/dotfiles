-- Awesome libraries
local awful = require("awful")
local beautiful = require("beautiful")

local command = 'bash -c "sensors \'nct6797-*\' | awk \'/Chipset/ {print substr($2, 2, length($2)-5)}\'"'

local mb_temp = awful.widget.watch(command, 2,
  function(widget, stdout)
    widget.markup = string.format("<span font='%s' foreground='%s'>%2d°C</span>", beautiful.bar.font, beautiful.bar.fg_white, stdout)
  end
)

return mb_temp