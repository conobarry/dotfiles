-- Awesome libraries
local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")

local prompt_popup = {}

local prompt = awful.widget.prompt {
  prompt = "Execute: "
}

-- local popup = awful.popup {
--   hide_on_right_click = false,
--   ontop = true,
--   type = "dialog",
--   width = 200,
--   height = 200,
--   widget = prompt,
--   border_color = "#ffffff",
--   border_width = 20
-- }

local prompt_popup = awful.popup {
  border_color = '#00ff00',
  border_width = 5,
  placement = awful.placement.centered,
  shape = gears.shape.rounded_rect,
  visible = false,
  ontop = true,
  widget = {
    widget  = wibox.container.margin,
    margins = 10,
    {
      layout = wibox.layout.fixed.vertical,
      {
        widget = awful.widget.prompt {
          prompt = "Execute: "
        }
      },
      {
        widget = wibox.container.background,
        bg     = '#ff00ff',
        clip   = true,
        shape  = gears.shape.rounded_bar,
        {
          widget = wibox.widget.textbox,
          text   = 'foobar',
        },
      },
      {
        widget = wibox.widget.progressbar,
        value = 0.5,
        forced_height = 30,
        forced_width  = 100,
      },
    },
  },
}

function prompt_popup:toggle()
  self.visible = not self.visible
end

return prompt_popup