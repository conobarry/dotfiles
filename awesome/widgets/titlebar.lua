local wibox = require("wibox")
local beautiful = require("beautiful")
local awful = require("awful")
local gears = require("gears")

local bindings = require("configuration.bindings")
local menu = require("widgets.menus.my_menu")
local global = require("configuration.global")
local inspect = require("lua_modules.inspect")

local titlebar_button = require("widgets.titlebar_button")

local function titlebar(client)

  local titlebar_widget = awful.titlebar(client, {
    size = beautiful.dpi(14)
  })

  -- Define titlebar buttons
  local maximize_button2 = awful.titlebar.widget.button(client, "maximized",
    function(cl)
      return cl.maximized
    end,
    function(cl, state)
      cl.maximized = not state
    end)
  -- c:connect_signal("property::maximized", widget.update)
  -- local maximize_sbutton = awful.titlebar.widget.maximizedbutton(client)
  local ontop_button = awful.titlebar.widget.ontopbutton(client)
  local floating_button = awful.titlebar.widget.floatingbutton(client)
  
  
  local minimize_button = titlebar_button {
    tooltip = "minimize",
    bg_normal = beautiful.titlebar.minimize_button.bg_normal,
    bg_focus = beautiful.titlebar.minimize_button.bg_focus,
    icon_normal = beautiful.titlebar.minimize_button.icon_normal,
    icon_focus = beautiful.titlebar.minimize_button.icon_focus,
  }
  
  minimize_button:connect_signal("button::press",
    function(titlebar, _, _, button)
      if (button == 1) then
        client.minimized = true
      end
    end
  )
  
  local maximize_button = titlebar_button {
    tooltip = "maximize",
    bg_normal = beautiful.titlebar.maximize_button.bg_normal,
    bg_focus = beautiful.titlebar.maximize_button.bg_focus,
    icon_normal = beautiful.titlebar.maximize_button.icon_normal,
    icon_focus = beautiful.titlebar.maximize_button.icon_focus,
  }
  
  maximize_button:connect_signal("button::press",
    function(titlebar, _, _, button)
      if (button == 1) then
        client.maximized = true
      end
    end
  )
  
  local restore_button = titlebar_button {
    tooltip = "restore",
    bg_normal = beautiful.titlebar.restore_button.bg_normal,
    bg_focus = beautiful.titlebar.restore_button.bg_focus,
    icon_normal = beautiful.titlebar.restore_button.icon_normal,
    icon_focus = beautiful.titlebar.restore_button.icon_focus,
  }
  
  local max_restore_button = client.maximized and restore_button or maximize_button

  
  restore_button:connect_signal("button::press",
    function(titlebar, _, _, button)
      if (button == 1) then
        client.maximized = false
      end
    end
  )
  
  local close_button = titlebar_button {
    tooltip = "close",
    bg_normal = beautiful.titlebar.close_button.bg_normal,
    bg_focus = beautiful.titlebar.close_button.bg_focus,
    icon_normal = beautiful.titlebar.close_button.icon_normal,
    icon_focus = beautiful.titlebar.close_button.icon_focus,
  }
  
  close_button:connect_signal("button::press",
    function(titlebar, _, _, button)
      if (button == 1) then
        client:kill()
      end
    end
  )
  
  

  -- Setup titlebar widget
  titlebar_widget:setup {
    widget = wibox.container.margin,
    -- bottom = beautiful.border_width,
    -- color = beautiful.border_normal,
    {
      layout = wibox.layout.align.horizontal,
      {
        -- Left
        --awful.titlebar.widget.iconwidget(c),
        --buttons = buttons,
        layout = wibox.layout.fixed.horizontal,
        -- menu_button,
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
        minimize_button,
        max_restore_button,
        close_button,
        -- maximize_button2,
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

  -- close_button:connect_signal("button::press",
  --   function(_, _, _, button)
  --     if (button == 1) then
  --       client:kill()
  --     end
  --   end
  -- )

  -- close_button:connect_signal("mouse::enter",
  --   function()
  --   end
  -- )

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
