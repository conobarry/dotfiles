-- Awesome libraries
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")

-- Local libraries
local wibarutils = require("utils.wibar")

local watch_command = [[bash -c "nvidia-smi --query-gpu=temperature.gpu,utilization.gpu,utilization.memory --format=csv,noheader,nounits"]]

local gpu_temp = wibox.widget {widget = wibox.widget.textbox, id = "temp"}
local gpu_usage = wibox.widget {widget = wibox.widget.textbox, id = "usage"}
local gpu_mem = wibox.widget {widget = wibox.widget.textbox, id = "mem"}

local gpu_temp_widget = wibarutils.make_shape(wibarutils.left_parallelogram, gpu_temp, "#90BE6D")
local gpu_usage_widget = wibarutils.make_shape(wibarutils.left_parallelogram, gpu_usage, "#90BE6D")

local gpu_widget = wibox.widget {
  widget = wibox.layout.fixed.horizontal,
  spacing = 0,
  gpu_temp_widget,
  gpu_usage_widget,
    -- widget = wibox.container.background,
  -- bg = "#90BE6D",
  -- shape = wibarutils.right_parallelogram,
  -- {
  --   widget = wibox.container.margin,
  --   right = 10,
  --   left = 10,
  --   {
  --     widget = wibox.layout.fixed.horizontal,
  --     spacing = 2,
  --     {
  --       widget = wibox.widget.textbox,
  --       id = "temp"
  --     },
  --     -- {
  --     --   widget = wibox.widget.textbox,
  --     --   id = "gpu"
  --     -- },
  --     -- {
  --     --   widget = wibox.widget.textbox,
  --     --   id = "mem"
  --     -- }
  --   }
  -- }
}

local watcher = awful.widget.watch(watch_command, 1,
  function(widget, stdout)

    local temp, usage, mem = stdout:match("(%d+).+(%d+).+(%d+)")

    widget:get_children_by_id("temp")[1].markup = string.format("<span font='%s' foreground='%s'>%2d</span>", beautiful.bar.font, "#fff", temp)
    widget:get_children_by_id("usage")[1].markup = string.format("<span font='%s' foreground='%s'>%3d%%</span>", beautiful.bar.font, "#fff", usage)
    --widget:get_children_by_id("mem")[1].markup = string.format("<span font='%s' foreground='%s'>%3d%%</span>", beautiful.bar.font, "#fff", mem)

  end, gpu_widget
)

return watcher