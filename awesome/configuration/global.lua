-- Global variable definitions

local global = {
  -- This is used later as the default terminal and editor to run.
  terminal = "kitty",
  browser = "firefox",
  file_manager = "thunar",
  editor = os.getenv("EDITOR") or "nano",
  explorer = "",
  -- Default modkey.
  -- Usually, Mod4 is the key with a logo between Control and Alt.
  -- If you do not like this or do not have such a key,
  -- I suggest you to remap Mod4 to another key using xmodmap or other tools.
  -- However, you can use another modifier like Mod1, but it may interact with others.
  modkey = "Mod1",
  wallpaper = nil
}

global.editor_cmd = global.terminal .. " -e " .. global.editor
global.explorer_cmd = global.terminal .. " -e " .. global.explorer

return global
