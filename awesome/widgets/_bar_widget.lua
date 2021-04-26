
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")

local bar_widget = {}

bar_widget.background = wibox.widget {
  widget = wibox.container.background,
  bg = beautiful.bar.bg_normal,
}

function bar_widget:new (o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return bar_widget
