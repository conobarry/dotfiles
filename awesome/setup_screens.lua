-- Capture variables
local screen = _G.screen

-- Awesome libraries
local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local wibox = require("wibox")
local dpi = beautiful.xresources.apply_dpi

-- Local libraries
local menu = require("widgets.menus.main_menu")
local bindings = require("configuration.bindings")
local wibarutils = require("utils.wibar")

-- Widgets
local taglist = require("bar_widgets.taglist")
local sensors = require("bar_widgets.sensors")
local volume = require("bar_widgets.volume.volume")
local date = require("bar_widgets.date")
local time = require("bar_widgets.time")
local systray = require("bar_widgets.systray")
-- local calendar_popup = require("widgets.calendar_popup")
-- local calendar = require("widgets.calendar")
local vpn = require("bar_widgets.vpn.vpn")
-- local redshift = require("widgets.redshift")
local window_title = require("bar_widgets.window_title")

local SPACING = 8

-- Sets wallpaper for a given screen
-- local function set_wallpaper(s)
--   -- Wallpaper
--   if beautiful.wallpaper then
--     local wallpaper = beautiful.wallpaper
--     -- If wallpaper is a function, call it with the screen
--     if type(wallpaper) == "function" then
--       wallpaper = wallpaper(s)
--     end
--     gears.wallpaper.maximized(wallpaper, s, true)
--   end
-- end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
--screen.connect_signal("property::geometry", set_wallpaper)

-- Launcher
local launcher = awful.widget.launcher({
  image = beautiful.launcher_icon,
  menu = menu
})

-- local launcher_container = wibox.widget {
--   widget = wibox.container.margin,
--   margins = beautiful.dpi(2),
--   {
--     widget = launcher
--   }
-- }

local launcher_container = wibarutils.make_shape(
  wibarutils.right_top_trapezium,
  wibox.widget {
    widget = wibox.container.margin,
    top = beautiful.dpi(2),
    bottom = beautiful.dpi(2),
    {
      widget = launcher
    }
  },
  beautiful.bar.bg_normal
)

local user = wibox.widget {
  widget = wibox.widget.textbox,
}

awful.spawn.easy_async_with_shell('echo "$(whoami)@$(cat /etc/hostname)"', function(stdout)
  user.markup = string.format("<span font='%s' foreground='%s'>%s</span>", beautiful.bar.font, "#000", stdout)
end)

-- Keyboard map indicator and switcher
local keyboardlayout = awful.widget.keyboardlayout()

-- local num_screens = screen:count()
-- local tag_table = {"1", "2", "3", "4", "5", "6", "7", "8", "9", "0"}
-- local table_length = 10


awful.screen.connect_for_each_screen(
  function(s)    

    -- Wallpaper
    --set_wallpaper(s)

    -- Create a promptbox for each screen
    s.promptbox = awful.widget.prompt()

    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.layoutbox = awful.widget.layoutbox(s)

    s.layoutbox:buttons( gears.table.join(
        awful.button({}, 1, function() awful.layout.inc(1) end),
        awful.button({}, 3, function() awful.layout.inc(-1) end),
        awful.button({}, 4, function() awful.layout.inc(1) end),
        awful.button({}, 5, function() awful.layout.inc(-1) end)
      )
    )

    -- Each screen has its own tag table.
    -- if (s.index == 1) then      
      awful.tag({"1", "2", "3", "4", "5"}, s, awful.layout.layouts[1])

    -- elseif (s.index == 2) then
      -- awful.tag({"6", "7", "8", "9", "0"}, s, awful.layout.layouts[1])
      -- awful.tag({"1", "2", "3", "4", "5"}, s, awful.layout.layouts[1])

    -- end

    -- Create a taglist widget
    s.taglist = taglist(s)

    -- Create a tasklist widget
    s.tasklist = window_title(s)
    -- s.tasklist = awful.widget.tasklist {
    --   screen  = s,
    --   filter  = awful.widget.tasklist.filter.focused,
    --   --buttons = bindings.tasklist_mouse,
    --   layout = wibox.widget {
    --     layout = wibox.layout.fixed.horizontal,
    --     spacing = dpi(6)
    --   },
    --   style = {
    --     align = "center",
    --     fg_focus = "#000"
    --   },
    --   widget_template = {
    --     widget = wibox.container.background,
    --     {
    --       widget = wibox.container.margin,
    --       left = dpi(4),
    --       right = dpi(4),
    --       {
    --         layout = wibox.layout.fixed.horizontal,
    --         -- {
    --         --   widget = wibox.container.margin,
    --         --   margins = dpi(4),
    --         --   {
    --         --     widget = wibox.widget.imagebox,
    --         --     id = "icon_role"
    --         --   }
    --         -- },
    --         {
    --           widget = wibox.widget.textbox,
    --           forced_width = dpi(400),
    --           id = "text_role"
    --         }
    --       }
    --     }
    --   }
    -- }

    local global_margin = wibox.widget {
      widget = wibox.container.margin,
      margins = dpi(3)
    }

    -- Create the bar
    s.bar = wibox({
      screen = s,
      --width = s.geometry.width - (beautiful.bar.margin * 2),
      --shape = wibarutils.right_trapezium,
      width = s.geometry.width,
      height = beautiful.bar.height,
      x = s.geometry.x + beautiful.bar.margin,
      y = s.geometry.y + beautiful.bar.margin,
      bg = beautiful.bar.bg_normal,
      border_width = beautiful.bar.border_width,
      border_color = beautiful.bar.border_color,
      visible = true,
      type = "dock" -- Important so that X11 knows it's a bar
    })
     s.bar:struts({top = beautiful.bar.height + beautiful.bar.margin})
     -- Add widgets to the bar (wibox)
    s.bar:setup {
      widget = wibox.container.margin,
      -- left = beautiful.bar.padding,
      -- right = beautiful.bar.padding,
      -- margins = beautiful.bar.padding,
      bottom = 1,
      color = "#000",
      {
        layout = wibox.layout.align.horizontal,
        expand = "inside",
        {
          widget = wibox.container.background,
          shape = wibarutils.right_top_trapezium,
          bg = beautiful.bar.bg_normal..00,
          {
            -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            spacing = beautiful.bar.spacing,
            -- date,
            launcher_container,
            user,
            systray,
            s.taglist,
          }
        },
        {
          widget = wibox.container.place,
          fill_vertical = true,
          content_fill_vertical = true,
          {
            widget = wibox.container.background,
            shape = wibarutils.bottom_trapezium,
            bg = beautiful.bar.bg_normal,
            {
              widget = wibox.container.margin,
              left = 10,
              right = 10,
              {
                widget = wibox.container.place,
                fill_horizontal = true,
                {
                  --widget = wibox.container.place,
                  -- Middle widget
                  widget = s.tasklist,
                }
              }
            }
          }
        },
        {
          widget = wibox.container.background,
          shape = wibarutils.left_top_trapezium,
          bg = beautiful.bar.bg_normal..00,
          {
            -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            spacing = beautiful.bar.spacing,
            sensors,
            --test,
            vpn,
            -- redshift,
            volume {},
            date,
            time,
          }
        }
      }  
    }   

  end
)



-- local calendar_widget = calendar_popup({
--   parent = date,
-- })

-- date:connect_signal("button::press", 
--   function(_, _, _, button)
--       if button == 1 then calendar_widget.toggle() end
--   end
-- )

-- local calendar_widget = calendar({
--   beautiful.bar.margin
-- })

-- date:connect_signal("button::press",
--   function(_, _, _, button)
--     if (button == 1) then
--       calendar_widget.visible = true
--     end
--   end
-- )
