-- Awesome libraries
local awful = require("awful")
local beautiful = require("beautiful")

local command = [[bash -c "nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits"]]

local gpu_temp = awful.widget.watch(command, 2,
  function(widget, stdout)
    widget.markup = string.format("<span font='%s' foreground='%s'>%3d</span>", beautiful.bar.font, beautiful.bar.fg_white, stdout)
  end
)

return gpu_temp