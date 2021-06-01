-- Awesome libraries
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")

local wibarutils = require("utils.wibar")
local cpu_temp = require("bar_widgets.sensors.cpu_temp")
local cpu_usage = require("bar_widgets.sensors.cpu_usage")
local gpu_temp = require("bar_widgets.sensors.gpu_temp")
local gpu_usage = require("bar_widgets.sensors.gpu_usage")
local memory_usage = require("bar_widgets.sensors.memory_usage")
-- local mb_temp = require("bar_widgets.sensors.mb_temp")
local chipset_temp = require("bar_widgets.sensors.chipset_temp")

local cpu_temp_color = beautiful.rainbow_colors[1]
local cpu_usage_color = beautiful.rainbow_colors[3]
local memory_usage_color = beautiful.rainbow_colors[5]
local gpu_temp_color = beautiful.rainbow_colors[6]
local gpu_usage_color = beautiful.rainbow_colors[7]
-- local mb_temp_color = beautiful.rainbow_colors[10]
local chipset_temp_color = beautiful.rainbow_colors[10]

local cpu_temp_widget = wibarutils.make_shape(wibarutils.left_parallelogram, cpu_temp, cpu_temp_color)
local cpu_usage_widget = wibarutils.make_shape(wibarutils.left_parallelogram, cpu_usage, cpu_usage_color)
local memory_usage_widget = wibarutils.make_shape(wibarutils.left_parallelogram, memory_usage, memory_usage_color)
local gpu_temp_widget = wibarutils.make_shape(wibarutils.left_parallelogram, gpu_temp, gpu_temp_color)
local gpu_usage_widget = wibarutils.make_shape(wibarutils.left_parallelogram, gpu_usage, gpu_usage_color)
-- local mb_temp_widget = wibarutils.make_shape(wibarutils.left_parallelogram, mb_temp, mb_temp_color)
local chipset_temp_widget = wibarutils.make_shape(wibarutils.left_parallelogram, chipset_temp, chipset_temp_color)


local sensors = wibox.widget {
  -- widget = wibox.container.margin,
  -- left = 4,
  -- right = 4,
  -- {
    widget = wibox.layout.fixed.horizontal,
    spacing = 0,
    cpu_temp_widget,
    cpu_usage_widget,
    memory_usage_widget,
    gpu_temp_widget,
    gpu_usage_widget,
    -- mb_temp_widget,
    chipset_temp_widget,
  -- }
}

return sensors