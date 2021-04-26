
-- Awesome libraries
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")

--local bar_widget = require("widgets.bar_widget")

local icon_switching_widget = {
  bg_normal = beautiful.bar.bg_normal,
  bg_focus = beautiful.bar.bg_focus
}

-- icon_switching_widget.background = wibox.widget {
--   widget = wibox.container.background,
--   bg = beautiful.bar.bg_normal,
-- }

-- icon_switching_widget.textbox = wibox.widget {
--   widget = wibox.widget.textbox,
--   visible = false
-- }

-- icon_switching_widget.imagebox = wibox.widget {
--   widget = wibox.widget.imagebox,
-- }

-- icon_switching_widget.icon_padding = wibox.widget {
--   widget = wibox.container.margin,
--   margins = beautiful.dpi(2)
-- }

-- icon_switching_widget.widget = wibox.widget
-- {
--   widget = icon_switching_widget.background,
--   {
--     widget = wibox.container.margin,
--     left = beautiful.bar.widget_padding,
--     right = beautiful.bar.widget_padding,
--     {
--       layout = wibox.layout.stack,
--       {
--         widget = icon_switching_widget.icon_padding,
--         {
--           widget = icon_switching_widget.imagebox,
--         }
--       },
--       {
--         widget = icon_switching_widget.textbox,
--       }
--     }
--   }
-- }

function icon_switching_widget.widget:update()
end

function icon_switching_widget:mouse_enter()
  self.widget:update()
  self.imagebox.visible = false
  self.textbox.visible = true
  self.background.bg = self.bg_focus
end

function icon_switching_widget:mouse_leave()
  self.widget:update()
  self.imagebox.visible = true
  self.textbox.visible = false
  self.background.bg = self.bg_normal
end


--icon_switching_widget.widget:update()

function icon_switching_widget:new(args)

  args = args or {}
  args.update = args.update or function() end

  local instance = {
  }

  setmetatable(instance, icon_switching_widget)

  function instance:update()
    args.update()
  end

  instance.background = wibox.widget {
    widget = wibox.container.background,
    bg = instance.bg_normal,
  }

  instance.textbox = wibox.widget {
    widget = wibox.widget.textbox,
    visible = false
  }

  instance.imagebox = wibox.widget {
    widget = wibox.widget.imagebox,
  }

  instance.icon_padding = wibox.widget {
    widget = wibox.container.margin,
    margins = beautiful.dpi(2)
  }

  instance.widget = wibox.widget
  {
    widget = instance.background,
    {
      widget = wibox.container.margin,
      left = beautiful.bar.widget_padding,
      right = beautiful.bar.widget_padding,
      {
        layout = wibox.layout.stack,
        {
          widget = instance.icon_padding,
          {
            widget = instance.imagebox,
          }
        },
        {
          widget = instance.textbox,
        }
      }
    }
  }

  instance.widget:connect_signal("mouse::enter",
    instance:mouse_enter()
  )

  instance.widget:connect_signal("mouse::leave",
    instance:mouse_leave()
  )

  return instance
end

return setmetatable(icon_switching_widget,
  {
    __call = function(_, ...) return icon_switching_widget:new(...) end
  }
)
