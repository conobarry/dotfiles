
local menu = require("widgets.menus.split_context_menu")
local global = require("configuration.global")

local client_menu = menu {
  items = {
    { type = "header", text = "Quickstart" },
    { "terminal", global.terminal },
    { "browser",  global.browser },
    { type = "header", text = "Applications" },
    { "text editors", sub1 },
    { "Header3", type = "header" },
    { type = "separator" },
    { "files", global.file_manager },
  }
}

return client_menu