-- Awesome libraries
local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local gears = require("gears")

local global = require("configuration.global")

local function to_icon_path(filename)
  return "/home/conor/convert/svgs/" .. filename .. ".png"
end

local icons = {
  disconnected = to_icon_path("vpn-disconnected"),
  connected = to_icon_path("vpn-connected"),
  error = to_icon_path("vpn-error")
}

local vpn = {
  is_connected = false
}

vpn.textbox = wibox.widget {
  widget = wibox.widget.textbox,
  visible = false
}

vpn.imagebox = wibox.widget {
  widget = wibox.widget.imagebox,
  image = icons.error,
  visible = true
}

-- local menu = awful.menu({
--   items = {
--     { "system",   menu_system, beautiful.launcher_icon },
--     { "awesome",  menu_awesome, beautiful.awesome_icon },
--     { "display",  menu_display },
--     { "terminal", global.terminal }
--   }
-- })

-- local command = "protonvpn status"
-- local color = beautiful.fg_normal

-- local watch = awful.widget.watch(command, 6,
--   function(widget, stdout)
--     widget.markup = string.format("<span foreground='%s'>%s</span>", color, stdout)
--   end
-- )

vpn.widget = wibox.widget
{
  -- widget = wibox.container.margin,
  -- color = "#000000",
  -- margins = 1,
  -- {
    widget = wibox.container.background,
    --bg = beautiful.bg_normal,
    {
      layout = wibox.layout.stack,
      {
        widget = wibox.container.margin,
        margins = beautiful.dpi(5),
        {
          widget = vpn.imagebox,
        }
      },
      {
        widget = wibox.container.margin,
        margins = beautiful.bar.padding,
        {
          widget = vpn.textbox,
        }
      }
    }
  -- } 
}
-- vpn.widget:connect_signal("button::press",
--   function(_, _, _, button)
--     if (button == 4) then
--       awful.spawn("pulsemixer --change-volume +2 --max-volume 100")
--     elseif (button == 5) then
--       awful.spawn("pulsemixer --change-volume -2")
--     elseif (button == 1) then
--       awful.spawn("pulsemixer --toggle-mute")
--     end
--     vpn.widget:update()
--   end
-- )

local function starts_with(str, start)
  return str:sub(1, #start) == start
end

function vpn.widget:update()
  awful.spawn.easy_async("protonvpn status",
    function (stdout)
      for line in stdout:gmatch("[^\r\n]+") do
        if starts_with(line, "Status") then

          local status = line:match(".+%s+(%w+)")

          if ( status == "Connected" ) then
            vpn.is_connected = true
            vpn.imagebox.image = icons.connected
          else
            vpn.is_connected = false
            if ( status == "Disconnected" ) then
              vpn.imagebox.image = icons.disconnected
            else
              vpn.imagebox.image = icons.error
            end
          end

          vpn.textbox.text = status

        end
      end
    end)
end

gears.timer {
  timeout = 2,
  call_now = true,
  autostart = true,
  callback = vpn.widget.update
}

vpn.menu = awful.menu({
  items = {
    {
      "connect fastest", function()
        awful.spawn(global.terminal .. " -e sudo protonvpn c -f")
      end
    },
    {
      "connect p2p", function()
        awful.spawn(global.terminal .. " -e sudo protonvpn c --p2p")
      end
    },
    {
      "connect tor", function()
        awful.spawn(global.terminal .. " -e sudo protonvpn c --tor")
      end
    }
  }
})

function vpn:show_menu()

  if vpn.is_connected then
    vpn.menu:add({
      "disconnect", function()
        awful.spawn(global.terminal .. " -e sudo protonvpn d")
      end
    }, 1)
  end

    -- table.insert(items, {
    --   "disconnect", function()
    --     awful.spawn(global.terminal .. " -e sudo protonvpn d")
    --   end
    -- })

  vpn.menu:show()
end

vpn.widget:connect_signal(
  "button::press",
  function(_, _, _, button)
    if (button == 1) then -- Left click shows status
      vpn.menu:hide()
    elseif (button == 3) then -- Right click shows context menu
      -- awful.menu({
      --   {
      --     { "connect", "chromium" }
      --   }
      -- }):show()
      vpn:show_menu()
    end
  end
)
-- vpn.widget:connect_signal(
--   "mouse::enter",
--   function()
--     vpn.imagebox.visible = false
--     vpn.textbox.visible = true
--   end
-- )

-- vpn.widget:connect_signal(
--   "mouse::leave",
--   function()
--     -- vpn.widget:update()
--     vpn.imagebox.visible = true
--     vpn.textbox.visible = false
--   end
-- )

return vpn.widget