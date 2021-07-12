
-- Awesome libraries
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")

--local bar_widget = require("widgets.bar_widget")

local titlebar_button = {
  bg_normal = beautiful.titlebar.bg_normal,
  bg_focus = beautiful.titlebar.bg_focus
}

function titlebar_button:new(args)

  args = args or {}
  args.action = args.action or function () end

  local instance = {
    bg_normal = args.bg_normal or self.bg_normal,
    bg_focus = args.bg_focus or self.bg_focus,
    icon_normal = args.icon_normal,
    icon_focus = args.icon_focus,
  }

  setmetatable(instance, self)

  function instance:action()
    args.action()
  end

  instance.background = wibox.widget {
    widget = wibox.container.background,
    bg = instance.bg_normal,
  }

  instance.imagebox = wibox.widget {
    widget = wibox.widget.imagebox,
    image = instance.icon_normal
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
      margins = beautiful.dpi(1),
      {
        widget = instance.imagebox,
      }
    }
  }

  instance.widget:connect_signal("mouse::enter", function (widget)
    -- titlebar_button:mouse_enter()
    -- self.widget:update()
    -- self.imagebox.visible = false
    -- self.textbox.visible = true
    instance.background.bg = instance.bg_focus
    instance.imagebox.image = instance.icon_focus
  end
    
  )

  instance.widget:connect_signal("mouse::leave", function (widget)
    -- titlebar_button:mouse_enter()
    -- self.widget:update()
    -- self.imagebox.visible = false
    -- self.textbox.visible = true
    instance.background.bg = instance.bg_normal
    instance.imagebox.image = instance.icon_normal
  end
  )

  return instance.widget
end

return setmetatable(titlebar_button,
  {
    __call = function(_, ...) return titlebar_button:new(...) end
  }
)
