-- Awesome libraries
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")

local watch_command = [[bash -c "cat /proc/stat | grep '^cpu.'"]]

local function starts_with(str, start)
  return str:sub(1, #start) == start
end

-- local usage_bar = wibox.widget {
--   widget = wibox.widget.progressbar,
--   max_value = 100,
--   value = 50,
--   forced_height = 100,
--   forced_width = 20,
--   -- border_width = 1,
--   -- border_color = beautiful.border_color,
--   background_color = "#ffffff",
--   color = "#ff0000",
-- }

local watcher = awful.widget.watch(watch_command, 1,
  function(widget, stdout)

    local i = 1
    local j = 1

    for line in stdout:gmatch("[^\r\n]+") do
      if starts_with(line, "cpu") then

        local name, user, nice, system, idle, iowait, irq, softirq, steal, guest, guest_nice =
          line:match("(%w+)%s+(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)")

        local total = user + nice + system + idle + iowait + irq + softirq + steal

        if widget[i] == nil then
          widget[i] = {}
        end

        local idle_diff = idle - ( widget[i].idle_prev == nil and 0 or widget[i].idle_prev )
        local total_diff = total - ( widget[i].total_prev == nil and 0 or widget[i].total_prev )

        local non_idle = total_diff - idle_diff
        local usage = ( 1000 * non_idle / total_diff + 5 ) / 10
        local usage = 100 * ( non_idle / total_diff )

        widget[i].idle_prev = idle
        widget[i].total_prev = total
        widget[i].usage = usage
        
        -- local diff_idle = idle - tonumber(cpu_usage[i]["idle_prev"] == nil and 0 or cpu_usage[i]["idle_prev"])
        -- local diff_total = total - tonumber(cpu_usage[i]["total_prev"] == nil and 0 or cpu_usage[i]["total_prev"])
        -- local diff_usage = (1000 * (diff_total - diff_idle) / diff_total + 5) / 10

        -- cpu_usage[i]["total_prev"] = total
        -- cpu_usage[i]["idle_prev"] = idle

        i = i + 1
      end
    end
    --widget:add_value(widget[1].usage)
    widget.markup = string.format("<span font='%s' foreground='%s'>%3.0f%%</span>",
      beautiful.bar.font, beautiful.bar.fg_white, widget[1].usage)
  end--,
  --progress_bar
)

-- local cpu_usage = wibox.widget {  
--   widget = usage_bar,
-- }

return watcher