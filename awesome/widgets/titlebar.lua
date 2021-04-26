local wibox = require("wibox")
local beautiful = require("beautiful")
local awful = require("awful")
local gears = require("gears")

local bindings = require("configuration.bindings")
local menu = require("widgets.menus.my_menu")
local global = require("configuration.global")
local inspect = require("lua_modules.inspect")

local function titlebar(client)

  local titlebar_widget = awful.titlebar(client, {
    size = beautiful.dpi(20)
  })

  -- Define titlebar buttons
  local close_button = awful.titlebar.widget.closebutton(client)
  local maximize_button = awful.titlebar.widget.maximizedbutton(client)
  local ontop_button = awful.titlebar.widget.ontopbutton(client)
  local floating_button = awful.titlebar.widget.floatingbutton(client)
  
  local menu_button = wibox.widget {
    widget = wibox.container.background,
    bg = "#000000"..00,
    {
      widget = wibox.container.margin,
      margins = 1,
      {
        widget = wibox.widget.imagebox,
        image = beautiful.titlebar_floating_button_focus_active,
        visible = true
      }
    }
  }

  -- Setup titlebar widget
  titlebar_widget:setup {
    widget = wibox.container.margin,
    bottom = beautiful.border_width,
    color = beautiful.border_normal,
    {
      layout = wibox.layout.align.horizontal,
      {
        -- Left
        --awful.titlebar.widget.iconwidget(c),
        --buttons = buttons,
        layout = wibox.layout.fixed.horizontal,
        menu_button,
        --buttons = bindings.titlebar_mouse,
      },
      {
        -- Middle
        widget = wibox.container.margin,
        --buttons = bindings.titlebar_mouse,
        -- left = beautiful.dpi(8),
        -- right = beautiful.dpi(8),
        -- top = beautiful.dpi(4),
        -- {
        --   layout = wibox.layout.stack,
        --   vertical_offset = beautiful.dpi(5),
        --   {
        --     widget = wibox.widget.separator,
        --     color = "#dedede"exact
        --   },
        --   {
        --     widget = wibox.widget.separator,
        --     color = "#dedede"
        --   },
        --   -- {
        --   --   widget = wibox.widget.separator,
        --   --   color = "#eee"
        --   -- },
        -- }
      },
      {
        -- Right
        layout = wibox.layout.fixed.horizontal(),
        {
          widget = wibox.container.margin,
          margins = 1,
          floating_button,
        },
        --awful.titlebar.widget.stickybutton(c),
        {
          widget = wibox.container.margin,
          margins = 1,
          ontop_button,
        },
        maximize_button,
        close_button,
      }
    }
  }

  local titlebar_menu = menu()
  -- {
  --   items = {
  --     { type="header", text=client.name },
  --     { "maximize",  
  --       function() 
  --         client.maximized = true
  --         client:raise()
  --       end
  --     },
  --     { type="header", text="Applications" },
  --     { type = "separator" },
  --     { "close", function() client:kill() end },
  --   }
  -- }

  titlebar_menu:add({ type="header", text=client.class })

  local maximize_entry = {}

  if client.maximized then
    maximize_entry = {
      text = "minimize"
    }
  else
    maximize_entry = {
      text = "maximize"
    }
  end

  titlebar_menu:add(maximize_entry)

  titlebar_menu:add({ type="separator" })
  titlebar_menu:add({ text="close", cmd=function() client:kill() end })

  titlebar_widget:connect_signal("button::press",
    function(titlebar, _, _, button)
      print(inspect(titlebar, {depth = 1}))
      if (button == 1) then  
        client:emit_signal("request::activate", "titlebar", {raise = true})
        awful.mouse.client.move(client)
      elseif (button == 3) then
        titlebar_menu:toggle()
      end
    end
  )

  close_button:connect_signal("button::press",
    function(_, _, _, button)
      if (button == 1) then
        client:kill()
      end
    end
  )

  return titlebar_widget

end

-- titlebar:connect_signal("button::press",
--   function(_, _, _, button)
--     if (button == 3) then
--       date_menu:toggle()
--     end
--   end
-- )

return titlebar
