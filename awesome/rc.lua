-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

print("--------------------------------------\nLoading rc.lua")

-- Capture variables
local awesome = _G.awesome
local client = _G.client
local root = _G.root
local screen = _G.screen

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")

local inspect = require("lua_modules.inspect")

-- Widget and layout library
local wibox = require("wibox")

-- Theme handling library
local beautiful = require("beautiful")
beautiful.init(gears.filesystem.get_configuration_dir() .. "themes/compact/theme.lua")
local dpi = beautiful.xresources.apply_dpi

-- Notification library
local naughty = require("naughty")
naughty.config.defaults['icon_size'] = 100

local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

-- User libraries
local global = require("configuration.global")
local bindings = require("configuration.bindings")
local rules = require("configuration.rules")
local wibarutils = require("utils.wibar")
local titlebar = require("widgets.titlebar")

-- local custom = require("layouts._custom")

-- Error handling
require("error_handling")


-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
  --awful.layout.suit.corner.nw,
  --custom,
  awful.layout.suit.tile.right,
  awful.layout.suit.floating,
  -- awful.layout.suit.tile.left,
  -- awful.layout.suit.tile.bottom,
  -- awful.layout.suit.tile.top,
  -- awful.layout.suit.fair,
  -- awful.layout.suit.fair.horizontal,
  -- awful.layout.suit.spiral,
  -- awful.layout.suit.spiral.dwindle,
  -- awful.layout.suit.max,
  -- awful.layout.suit.max.fullscreen,
  -- awful.layout.suit.magnifier,
  
  -- awful.layout.suit.corner.ne,
  -- awful.layout.suit.corner.sw,
  -- awful.layout.suit.corner.se,
}
-- }}}

-- Setup screens
require("setup_screens")
--require("layout")

-- Set Bindings
root.buttons(bindings.mouse.global)
root.keys(bindings.keyboard.global)

-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = rules

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal(
  "manage",
  function(c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
      -- Prevent clients from being unreachable after screen count changes.
      awful.placement.no_offscreen(c)
    end
  end
)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal(
  "request::titlebars",
  function(c)
    titlebar(c)
  end
)

local redshift_script = "/home/conor/.config/redshift/redshift.sh"

-- Calls whenever a client goes fullscreen
client.connect_signal("request::geometry", function(c, context, ...)
    if context == "fullscreen" then

      local screen_name = ""
      for k in pairs(c.screen.outputs) do
        screen_name = k
      end

      local redshift_cmd = ""

      if c.fullscreen then
                        
        print("Fullscreen on screen: " .. screen_name)

        redshift_cmd = string.format("sh %s disable %s", redshift_script, screen_name)
        print(redshift_cmd)

      else

        print("Closing fullscreen")

        redshift_cmd = string.format("sh %s enable %s", redshift_script, screen_name)

      end

      awful.spawn.easy_async_with_shell(redshift_cmd, function(stdout)
        print(stdout)
      end)

    end
end)

-- client.connect_signal("property::floating", function(c)
--   if c.floating then
--       awful.titlebar.show(c)
--   else
--       awful.titlebar.hide(c)
--   end
-- end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal(
  "mouse::enter",
  function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
  end
)

client.connect_signal(
  "focus",
  function(c)
    c.border_color = beautiful.border_focus
    --print(c.name)
  end
)

client.connect_signal(
  "unfocus",
  function(c)
    c.border_color = beautiful.border_normal
  end
)

-- client.connect_signal(
--   "property::maximized",
--   function(c)
--     c.maximized = false
--   end
-- )


-- client.connect_signal("manage",
--   function(c, startup)
--     c.shape = function(cr, w, h)
--       gears.shape.rounded_rect(cr, w, h, 6)
--     end
--   end
-- )
-- }}}

-- Autoruns
awful.spawn.with_shell("~/.config/awesome/configuration/autorun.sh")
