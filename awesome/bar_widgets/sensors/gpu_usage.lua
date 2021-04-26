-- Awesome libraries
local awful = require("awful")
local beautiful = require("beautiful")

local command = [[bash -c "nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits"]]

local gpu_usage = awful.widget.watch(command, 2,
  function(widget, stdout)
    widget.markup = string.format("<span font='%s' foreground='%s'>%2d%%</span>", beautiful.bar.font, beautiful.bar.fg_white, stdout)
  end
)

return gpu_usage