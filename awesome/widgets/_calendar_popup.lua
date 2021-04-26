-------------------------------------------------
-- Calendar Widget for Awesome Window Manager
-- Shows the current month and supports scroll up/down to switch month
-- More details could be found here:
-- https://github.com/streetturtle/awesome-wm-widgets/tree/master/calendar-widget
-- @author Pavel Makhov
-- @copyright 2019 Pavel Makhov
-------------------------------------------------

-- Awesome libraries
local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local gears = require("gears")

local calendar_widget = {}

local function worker(args)

  local theme = {
    bg = "#ffffff",
    fg = "#000000",
    focus_date_bg = "#000000",
    focus_date_fg = "#ffffff",
    weekend_day_bg = "#AAAAAA",
    weekday_fg = "#000000",
    header_fg = "#000000",
    border = "#CCCCCC"
  }

  --local args = args or {}
  local parent_widget = args.parent

  local function rounded_shape(size)
    return function(cr, width, height)
      gears.shape.rounded_rect(cr, width, height, size)
    end
  end

  local styles = {
    month = {
      padding = 4,
      bg_color = theme.bg,
      border_width = 0
    },
    normal = {
      markup = function(t) return t end,
      shape = rounded_shape(4)
    },
    focus = {
      fg_color = theme.focus_date_fg,
      bg_color = theme.focus_date_bg,
      markup = function(t) return '<b>' .. t .. '</b>' end,
      shape = rounded_shape(4)
    },
    header = {
      fg_color = theme.header_fg,
      bg_color = theme.bg,
      markup = function(t) return '<b>' .. t .. '</b>' end
    },
    weekday = {
      fg_color = theme.weekday_fg,
      bg_color = theme.bg,
      markup = function(t) return '<b>' .. t .. '</b>' end
    }
  }

  local function decorate_cell(widget, flag, date)

    if flag == 'monthheader' and not styles.monthheader then
      flag = 'header'
    end

    -- highlight only today's day
    if flag == 'focus' then
      local today = os.date('*t')
      if today.month ~= date.month then flag = 'normal' end
    end

    local props = styles[flag] or {}
    if props.markup and widget.get_text and widget.set_markup then
      widget:set_markup(props.markup(widget:get_text()))
    end

    -- Change bg color for weekends
    local d = {
      year = date.year,
      month = (date.month or 1),
      day = (date.day or 1)
    }

    local weekday = tonumber(os.date('%w', os.time(d)))

    local default_bg = (weekday == 0 or weekday == 6) and theme.weekend_day_bg or theme.bg

    local ret = wibox.widget {
      {
        {widget, halign = 'center', widget = wibox.container.place},
        margins = (props.padding or 2) + (props.border_width or 0),
        widget = wibox.container.margin
      },
      shape = props.shape,
      shape_border_color = props.border_color or '#000000',
      shape_border_width = props.border_width or 0,
      fg = props.fg_color or theme.fg,
      bg = props.bg_color or default_bg,
      widget = wibox.container.background
    }

    return ret

  end

  local calendar = wibox.widget {
    widget = wibox.widget.calendar.month,
    date = os.date('*t'),
    font = beautiful.get_font(),
    fn_embed = decorate_cell,
    --long_weekdays = true,
  }

  local popup = awful.popup {
    ontop = true,
    visible = false,
    shape = gears.shape.rounded_rect,
    border_width = 2,
    border_color = beautiful.border_normal,
    screen = awful.screen.focused(),
    widget = calendar
  }

  -- Connect mouse buttons to scroll through months
  popup:buttons(awful.util.table.join(

    -- Scrolling up goes to the next month
    awful.button({}, 4,
      function()
        local date = calendar:get_date()
        date.month = date.month + 1
        calendar:set_date(nil)
        calendar:set_date(date)
        popup:set_widget(calendar)
      end
    ),

    -- Scrolling down goes to the previous month
    awful.button({}, 5,
      function()
        local date = calendar:get_date()
        date.month = date.month - 1
        calendar:set_date(nil)
        calendar:set_date(date)
        popup:set_widget(calendar)
      end
    )
  ))

  function calendar_widget.toggle()

    if popup.visible then

      -- to faster render the calendar refresh it and just hide
      calendar:set_date(nil) -- the new date is not set without removing the old one
      calendar:set_date(os.date('*t'))
      popup:set_widget(nil) -- just in case
      popup:set_widget(calendar)
      popup.visible = not popup.visible

    else
      popup.x = parent_widget.x
      popup.visible = true
    end
  end

  return calendar_widget

end

return setmetatable(calendar_widget, {
  __call = function(_, ...)
    return worker(...)
  end
})
