-- Awesome libraries
local awful = require("awful")
local beautiful = require("beautiful")

local command = [[bash -c "radeontop -l 1 -d - | awk -F',' 'NR==2 {print $2}'"]]

local gpu_usage = awful.widget.watch(command, 1,
  function(widget, stdout)
    local usage = stdout:match("%w+%s+(%d+)")
    widget.markup = string.format("<span font='%s' foreground='%s'>%3d%%</span>", beautiful.bar.font, beautiful.bar.fg_white, usage)
    -- widget.markup = usage
  end
)

return gpu_usage