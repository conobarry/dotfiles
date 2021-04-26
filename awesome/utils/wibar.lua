local beautiful = require("beautiful")
local wibox     = require("wibox")
local gears = require("gears")

local wibar = {}

wibar.right_parallelogram = function(cr, width, height)
  gears.shape.transform(gears.shape.parallelogram) : translate(0,0)(cr, width, height, width - 5)
end

wibar.left_parallelogram = function(cr, width, height)
  gears.shape.transform(gears.shape.parallelogram) : translate(width,0)(cr, -width, height, -width + 5)
end

wibar.right_top_trapezium = function(cr, width, height)
  cr:move_to(0, 0)
  cr:line_to(width, 0)
  cr:line_to(width - 5, height)
  cr:line_to(0, height)
  cr:close_path()
end

wibar.left_top_trapezium = function(cr, width, height)
  cr:move_to(0, 0)
  cr:line_to(width, 0)
  cr:line_to(width, height)
  cr:line_to(5, height)
  cr:close_path()
end

wibar.bottom_trapezium = function(cr, width, height)
  cr:move_to(5, 0)
  cr:line_to(width - 5, 0)
  cr:line_to(width, height)
  cr:line_to(0, height)
  cr:close_path()
end

wibar.make_shape = function(shape, widget, color)
  return wibox.widget {
    -- widget = wibox.container.margin,
    -- margins = beautiful.dpi(1),
    -- color = "#000",
    -- {
      widget = wibox.container.background,
      bg = color,
      shape = shape,
      {
        widget = wibox.container.margin,
        right = beautiful.dpi(10),
        left = beautiful.dpi(10),
        widget
      }
    }
  -- }
end

return wibar