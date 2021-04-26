local wibox = require("wibox")
local beautiful = require('beautiful')

-- local calendar = require("widgets.calendar")

-- This will get the date suffix for any number
local function get_day_with_suffix()

  local day_switch = {
    [1] = "st",
    [2] = "nd",
    [3] = "rd",
  }

  local day = os.date("%d")

  -- If the first digit of the day is a 0, remove it
  local day_first_digit = string.sub(day, 1, 1)
  if (day_first_digit == "0") then
    print("true")
    day = day:match("0*(%d+)")
  end  

  -- Get the last digit of the date as a number
  local day_last_digit = tonumber(string.sub(day, -1))

  -- Normally the suffix is as shown in the day_switch table
  local suffix = day_switch[day_last_digit] and day_switch[day_last_digit] or "th"

  -- But any numbers that end in 11, 12 or 13 will actually use "th"
  -- Check if the second to last digit is a 1, and if so use "th"
  if (string.len(day) > 1) then

    local day_second_last_digit = tonumber(string.sub(day, -2, -2))

    if (day_second_last_digit == 1) then
      suffix = "th"
    end
  end

  return string.format("%s%s", day, suffix)
end

local function get_format(time_format)
  return string.format("<span font='%s'>%s</span>", beautiful.bar.font, time_format)
end

local short_format = get_format("%d-%m-%y")
local long_format = get_format(string.format("%%a %s %%b", get_day_with_suffix()))

-- Create a textclock widget
-- The time format is built in to lua: http://www.lua.org/pil/22.1.html
local textclock = wibox.widget.textclock(get_format(long_format), 1)

local date = wibox.widget
{
  -- widget = wibox.container.margin,
  -- color = "#000000",
  -- margins = 1,
  -- {
    widget = wibox.container.background,
    --bg = beautiful.bg_normal,
    {
      widget = wibox.container.margin,
      margins = beautiful.bar.padding,
      {
        widget = textclock
      }
    }
  -- }
}

-- local menu = require("context-menu")
local menu = require("widgets.menus.split_context_menu")
local global = require("configuration.global")

local sub2 = {
  { "terminal", global.terminal },
  { "browser", global.browser },
}

local sub1 = {
  { "terminal", global.terminal },
  { "browser", global.browser },
  { "sub2", sub2 }
}

local date_menu = menu {
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

date:connect_signal("button::press",
  function(_, _, _, button)
    if (button == 3) then
      date_menu:toggle()
    end
  end
)

return date