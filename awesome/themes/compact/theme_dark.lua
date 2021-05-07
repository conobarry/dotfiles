---------------------------
-- Default awesome theme --
---------------------------

local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local gfs = require("gears.filesystem")
local shape = require("gears.shape")
local theme_path = gfs.get_configuration_dir() .. "themes/default/"

local function to_icon_path(filename)
  return "/home/conor/convert/svgs/" .. filename .. ".png"
end

local theme = {
  dpi = dpi
}

-- Colors -----------------------------------------------

local colors = {
  -- base02  = "#073642",
  -- base01  = "#586e75",
  -- base00  = "#657b83",
  -- base0   = "#839496",
  -- base1   = "#93a1a1",
  -- base2   = "#eee8d5",
  -- base3   = "#fdf6e3",
  -- yellow  = "#b58900",
  -- orange  = "#cb4b16",
  -- magenta = "#d33682",
  -- violet  = "#6c71c4",
  -- blue    = "#268bd2",
  -- cyan    = "#2aa198",
  -- green   = "#378037",
  -- light_grey = "#999999",
  -- accent  = "#cb4b16",
  -- accent_dark = "#a13d12",
  -- accent_light = "#99BBD6",
    
  red     = "#BD3333",
  white = "#ffffff",
  black = "#000000",
  off_white = "#ede7e3", -- off-white
  dark_green = "#23856d", -- dark green
  light_green = "#6cbda8",
  off_black  = "#002b36", -- off-black (dark blue)
}

theme.rainbow_colors = {
  "#F94144", -- Red Salsa
  "#F3722C", -- Orange Red
  "#F8961E", -- Yellow Orange Color Wheel
  "#F9844A", -- Mango Tango
  "#F9C74F", -- Maize Crayola
  "#90BE6D", -- Pistachio
  "#43AA8B", -- Zomp
  "#4D908E", -- Cadet Blue
  "#577590", -- Queen Blue
  "#277DA1", -- CG Blue
}

theme.rainbow_colors_light = {
  "#fca1a3", -- Salmon Pink
  "#f9b895", -- Tumbleweed
  "#fccb90", -- Deep Champagne
  "#fcc1a3", -- Apricot
  "#fce2a6", -- Banana Mania
  "#c8dfb7", -- Tea Green
  "#9dd8c6", -- Middle Blue Green
  "#a1cccb", -- Opal
  "#a7baca", -- Cadet Blue Crayola
  "#82c4e1" -- Sky Blue
}

theme.font = "sans 9"

theme.bg_normal = colors.light_green
theme.bg_focus = colors.dark_green
theme.bg_urgent = colors.red
--theme.bg_minimize = "#444444"
theme.bg_systray = colors.off_white

theme.fg_normal = colors.off_black
--theme.fg_focus = "#fff"
--theme.fg_urgent = "#ffffff"
--theme.fg_minimize = "#ffffff"

theme.useless_gap = dpi(4)
theme.border_width = dpi(1)
theme.border_normal = colors.black
theme.border_focus = colors.black--"#535d6c"
theme.border_marked = colors.black --"#91231c"

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- taglist_[bg|fg]_[focus|urgent|occupied|empty|volatile]
-- tasklist_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- prompt_[fg|bg|fg_cursor|bg_cursor|font]
-- hotkeys_[bg|fg|border_width|border_color|shape|opacity|modifiers_fg|label_bg|label_fg|group_margin|font|description_font]
-- Example:
--theme.taglist_bg_focus = "#ff0000"

theme.launcher_icon = to_icon_path("archlinux-dark")

theme.bar = {
  bg_normal = colors.off_black,
  bg_focus = theme.bg_focus,
  font = "Roboto Mono 9",
  fg_white = colors.white,
  fg_black = colors.black,
  height = dpi(50),
  --margin = 2 * theme.useless_gap,
  margin = dpi(0),
  padding = dpi(4),
  border_width = dpi(0),
  border_color = theme.border_normal,
  icon_padding = dpi(2),
  widget_padding = dpi(4),
  spacing = dpi(6)
}

theme.tasklist_bg_focus = colors.black..00
theme.tasklist_bg_normal = colors.black..00
theme.tasklist_font = theme.bar.font


-- Generate taglist squares:
local taglist_square_size = dpi(4)
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(taglist_square_size, theme.fg_normal)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(taglist_square_size, theme.fg_normal)
theme.taglist_font = theme.bar.font

theme.titlebar_bg_normal = theme.off_white
theme.titlebar_bg_focus = theme.off_white

-- Variables set for theming notifications:
-- notification_font
-- notification_[bg|fg]
-- notification_[width|height|margin]
-- notification_[border_color|border_width|shape|opacity]

-- The screen snap guides
theme.snap_border_width = dpi(4)

theme.menu = {
  bg_normal = theme.bar.bg_normal,
  bg_focus = theme.bg_focus,
  fg_normal = theme.fg_normal,
  fg_focus = theme.fg_focus,
  height = dpi(18),
  width = dpi(100),
  submenu_icon = theme_path .. "submenu.png"
}

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_bg_normal = colors.off_white
theme.menu_bg_focus = colors.dark_green
theme.menu_submenu_icon = theme_path .. "submenu.png"
theme.menu_height = dpi(15)
theme.menu_width = dpi(100)

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"

-- Define the image to load
theme.titlebar_close_button_normal = to_icon_path("window-close")
theme.titlebar_close_button_focus  = to_icon_path("window-close")

theme.titlebar_minimize_button_normal = to_icon_path("window-minimize")
theme.titlebar_minimize_button_focus  = to_icon_path("window-minimize")

theme.titlebar_ontop_button_normal_inactive = to_icon_path("window-pin")
theme.titlebar_ontop_button_focus_inactive  = to_icon_path("window-pin")
theme.titlebar_ontop_button_normal_active   = to_icon_path("window-unpin")
theme.titlebar_ontop_button_focus_active    = to_icon_path("window-unpin")

theme.titlebar_sticky_button_normal_inactive = theme_path .. "titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive  = theme_path .. "titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active   = theme_path .. "titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active    = theme_path .. "titlebar/sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive = to_icon_path("window-grid")
theme.titlebar_floating_button_focus_inactive  = to_icon_path("window-grid")
theme.titlebar_floating_button_normal_active   = to_icon_path("window-floating")
theme.titlebar_floating_button_focus_active    = to_icon_path("window-floating")

theme.titlebar_maximized_button_normal_inactive = to_icon_path("window-maximize")
theme.titlebar_maximized_button_focus_inactive  = to_icon_path("window-maximize")
theme.titlebar_maximized_button_normal_active   = to_icon_path("window-minimize")
theme.titlebar_maximized_button_focus_active    = to_icon_path("window-minimize")

theme.wallpaper = theme_path .. "ibm-rainbow-wallpaper.png"

-- You can use your own layout icons like this:
theme.layout_fairh = theme_path .. "layouts/fairhw.png"
theme.layout_fairv = theme_path .. "layouts/fairvw.png"
theme.layout_floating = theme_path .. "layouts/floatingw.png"
theme.layout_magnifier = theme_path .. "layouts/magnifierw.png"
theme.layout_max = theme_path .. "layouts/maxw.png"
theme.layout_fullscreen = theme_path .. "layouts/fullscreenw.png"
theme.layout_tilebottom = theme_path .. "layouts/tilebottomw.png"
theme.layout_tileleft = theme_path .. "layouts/tileleftw.png"
theme.layout_tile = theme_path .. "layouts/tilew.png"
theme.layout_tiletop = theme_path .. "layouts/tiletopw.png"
theme.layout_spiral = theme_path .. "layouts/spiralw.png"
theme.layout_dwindle = theme_path .. "layouts/dwindlew.png"
theme.layout_cornernw = theme_path .. "layouts/cornernww.png"
theme.layout_cornerne = theme_path .. "layouts/cornernew.png"
theme.layout_cornersw = theme_path .. "layouts/cornersww.png"
theme.layout_cornerse = theme_path .. "layouts/cornersew.png"

-- Generate Awesome icon:
theme.awesome_icon = theme_assets.awesome_icon(theme.menu_height, theme.bg_focus, theme.fg_focus)

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
