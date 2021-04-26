-- Awesome libraries
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")

local watch_command = [[bash -c "free -m | sed -n -e '2{p;q}'"]]

local watcher = awful.widget.watch(watch_command, 2,
  function(widget, stdout)

    local total, used, free, shared, buff, available =
      stdout:match(".+%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)")

    local usage = ( used / total ) * 100

    widget.markup = string.format("<span font='%s' foreground='%s'>%2.0f%%</span>", beautiful.bar.font, beautiful.bar.fg_white or beautiful.fg_normal, usage)
  end
)

return watcher