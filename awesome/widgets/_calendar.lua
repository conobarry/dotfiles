local awful = require('awful')
local beautiful = require('beautiful')
local wibox = require('wibox')
local gears = require('gears')

local dpi = require('beautiful').xresources.apply_dpi

local textclock = wibox.widget.textclock('<span font="'..beautiful.bar.font..'">%d.%m.%Y\n     %H:%M</span>')

local date_widget = wibox.widget {
  widget = wibox.container.margin,
  margins = beautiful.bar.padding,
  {
    widget = textclock
  }
}

local DatePanel = function(parent)

  local margin = beautiful.bar.margin
  local width = dpi(88)
  local height = dpi(25)
  local screen = awful.screen.focused()

  local panel = wibox({
    ontop = false,
    screen = screen,
    height = height,
    width = width,
    x = screen.geometry.x + parent.x,
    y = screen.geometry.y + parent.y,
    stretch = false,
    bg = beautiful.bg_normal,
    fg = beautiful.fg_normal
  })

  panel:setup{layout = wibox.layout.fixed.horizontal, date_widget}

  return panel
end

return DatePanel
