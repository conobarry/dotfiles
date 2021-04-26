
-- Awesome libraries
local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local dpi = beautiful.xresources.apply_dpi

local client_menu = require("widgets.menus.client_menu")

local window_title = {}

function window_title:new(screen)

  local _window_title = awful.widget.tasklist {
    screen  = screen,
    filter  = awful.widget.tasklist.filter.focused,
    --buttons = bindings.tasklist_mouse,
    layout = wibox.widget {
      layout = wibox.layout.fixed.horizontal,
      spacing = dpi(6)
    },
    style = {
      align = "center",
      fg_focus = beautiful.fg_normal
    },
    widget_template = {
      widget = wibox.container.background,
      {
        widget = wibox.container.margin,
        left = dpi(4),
        right = dpi(4),
        {
          layout = wibox.layout.fixed.horizontal,
          -- {
          --   widget = wibox.container.margin,
          --   margins = dpi(4),
          --   {
          --     widget = wibox.widget.imagebox,
          --     id = "icon_role"
          --   }
          -- },
          {
            widget = wibox.widget.textbox,
            forced_width = dpi(400),
            id = "text_role"
          }
        }
      }
    }
  }

  _window_title:connect_signal("button::press",
    function(_, _, _, button)
      if (button == 3) then
        client_menu:show()
      end
    end
  )

  return _window_title

end

return setmetatable(window_title,
  {
    __call = function(_, ...) return window_title:new(...) end
  }
)
