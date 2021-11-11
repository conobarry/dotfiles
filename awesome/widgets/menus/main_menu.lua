-- Capture variables
local awesome = _G.awesome

-- Awesome libraries
local awful = require("awful")
local beautiful = require("beautiful")

local hotkeys_popup = require("awful.hotkeys_popup")
local wibox = require("wibox")

-- Local libraries
local menu = require("widgets.menus.my_menu")
local global = require("configuration.global")
---[[

local menu_system = {
  { "lock", "xscreensaver-command -lock" },
  { "sleep", "systemctl suspend" },
  { "reboot", "reboot" },
  { "shutdown", "shutdown now" }
}

local menu_awesome = {
  { "config", "code /home/conor/.config/awesome.code-workspace" },
  { "hotkeys",      function()
      hotkeys_popup.show_help(nil, awful.screen.focused())
    end },
  --{ "manual",       global.terminal .. " -e man awesome" },
  --{ "edit config",  global.editor_cmd .. " " .. awesome.conffile },
  { "restart",      awesome.restart },
  { "quit",         function() awesome.quit() end }
}

local menu_display = {
  { "detect", function() 
    awful.spawn("python3 ~/.setupscreens/autodetect.py")
    awesome.restart()
  end }
}

local main_menu = menu({
  items = {
    { "terminal", global.terminal },
    { "browser",  global.browser },
    { "files",    global.file_manager },
    { "code", "code" },
    { type="separator" },
    { "system",   menu_system, beautiful.launcher_icon },
    { "awesome",  menu_awesome, beautiful.awesome_icon },
    { "display",  menu_display },    
  }
})

-- -- Menubar configuration
-- menubar.utils.terminal = global.terminal -- Set the terminal for applications that require it

--]]

return main_menu