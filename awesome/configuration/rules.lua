--[[
Docs: https://awesomewm.org/doc/api/libraries/awful.rules.html

How rules work:

Whenever a client is started it is matched against the rules in the rules table.
If a client matches multiple rules, they are applied in the order they are entered.
A client that matches a rule will be assigned the defined properties.

Rule defintions:
  "rule" or "rule_any" (required)
    matches if a client matches all, or any of the defined rules.

  "except" or "except_any" (optional)
    define exceptions to the rules.

Property assignment:
  "properties" (required)
    the list of properties that will be set for the clients that match the rule(s).

Properties:
  The client can be matched on and assigned any of the properties defined in
    the docs. To understand what they mean see:
      https://awesomewm.org/doc/api/classes/client.html

  Some useful definitons are:
    class     - the second string of the result of "xprop WM_CLASS"
    instance  - the first string of the result of "xprop WM_CLASS"
    name      - The text in the titlebar, the result of "xprop WM_NAME"
    role      - unknown

  For more properties shown by "xprop" see:
    https://linux.die.net/man/1/xprop
  For definitons of these properties see:
    https://tronche.com/gui/x/xlib/ICC/

Property values:
  If the value of the property is a function, the value of the property
    is set to the return value of the function.
  If the value is a string, the string.match function is used to match on it.
]]

local awful = require("awful")
local beautiful = require("beautiful")
local bindings = require("configuration.bindings")

local rules = {

  -- All clients will match this rule.
  {
    rule = {},
    properties = {
      border_width = beautiful.border_width,
      border_color = beautiful.border_normal,
      focus = awful.client.focus.filter,
      raise = true,
      keys = bindings.keyboard.client,
      buttons = bindings.mouse.client,
      screen = awful.screen.preferred,
      placement = awful.placement.no_overlap + awful.placement.no_offscreen + awful.placement.centered,
      floating = true, -- All clients are now floating by default
    }
  },

  -- Add titlebars to normal clients and dialogs
  {
    rule_any = {
      type = {
        "normal",
        "dialog"
      }
    },
    properties = {titlebars_enabled = true}
  },

  -- Tiling clients
  {
    rule_any = {
      instance = {
        "chromium",
        "code-oss",
        "urxvt",
        "discord",
        "spotify",
        "Steam",
        "libreoffice",
        "atom",
        "vlc"
      },
      class = {
        "firefox",
        "libreoffice-writer",
        "Spotify"
      }
    },
    properties = { 
      floating = false,
      --titlebars_enabled = false
    }
  },

  -- Floating clients.
  {
    rule_any = {
      instance = {
        "DTA", -- Firefox addon DownThemAll.
        "copyq", -- Includes session name in class.
        "pinentry",
        "dolphin", -- Dolphin file manager
        -- Terminator when called with a set geometry
        "terminator --geometry",
        "qemu" -- Machine emulator
      },
      class = {
        "Arandr",
        "Blueman-manager",
        "Gpick",
        "Kruler",
        "MessageWin", -- kalarm.
        "Sxiv",
        "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
        "Wpa_gui",
        "veromix",
        "xtightvncviewer"
      },
      -- Note that the name property shown in xprop might be set slightly after creation of the client
      -- and the name shown there might not match defined rules here.
      name = {
        "Event Tester", -- xev.
        "Terminator Preferences",
      },
      role = {
        "AlarmWindow", -- Thunderbird's calendar.
        "ConfigManager", -- Thunderbird's about:config.
        "pop-up" -- e.g. Google Chrome's (detached) Developer Tools.
      },
      type = {
        "splash", -- Application splash screens
        "dialog",
        "menu",
        "toolbar",
        "utility",
        "dropdown_menu",
        "popup_menu",
        "notification",
        "combo",
        "dnd"
      }
    },
    properties = {
      floating = true,
      titlebars_enabled = true
    }
  },

  -- Always on top
  {
    rule_any = {
      instance = {
        "xvkbd"
      }
    },
    properties = {
      focus = true,
      ontop = true
    }
  },

  -- Set Discord to always map on the tag named "2" on screen 2.
  {
    rule = { class = "discord" },
    properties = {
      screen = 2,
      tag = "7"
    }
  },
  {
    rule = { instance = "spotify" },
    properties = {
      screen = 2,
      tag = "8",
      floating = false
    }
  },
  {
    rule = { role = "_NET_WM_STATE_FULLSCREEN" },
    properties = {
      floating = true
    } 
  },
  -- Make urxvt take up all the space it's given
  {
    rule_any = {
      instance = {
        "urxvt",
      }
    },
    properties = { size_hints_honor = false }
  },
}

return rules