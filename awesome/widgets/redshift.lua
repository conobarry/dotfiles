
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")

local icon_switching_widget = require("widgets.icon_switching_widget")

local redshift = icon_switching_widget:new({
  temp = 1000,
  is_on = false
})

local function to_icon_path(filename)
  return "/home/conor/convert/svgs/" .. filename .. ".png"
end

local icons = {
  on = to_icon_path("redshift")
}

redshift.textbox.text = redshift.temp
redshift.imagebox.image = icons.on
redshift.icon_padding.margins = beautiful.dpi(5)

-- redshift.widget = wibox.widget
-- {
--   widget = redshift.background,
--   {
--     widget = wibox.container.margin,
--     left = beautiful.bar.widget_padding,
--     right = beautiful.bar.widget_padding,
--     {
--       layout = wibox.layout.stack,
--       {
--         widget = wibox.container.margin,
--         margins = beautiful.dpi(5),
--         {
--           widget = redshift.imagebox,
--         }
--       },
--       {
--         widget = redshift.textbox,
--       }
--     }
--   }
-- }

function redshift.widget:update()
  redshift.textbox.text = redshift.temp
  -- awful.spawn.easy_async(VOL_CMD,
  --   function (stdout)

  --     local value = string.match(stdout, "%d+")
  --     local is_muted = string.match(stdout, ".+%c+(%d)")

  --     value = tonumber(value)
  --     is_muted = ( tonumber(is_muted) == 1 )

  --     redshift.textbox.markup = string.format("<span font='%s'>%s</span>", beautiful.bar.font, ( is_muted and "M" or value ))

  --   end)
end

function redshift:set_temp(temp)

  if ( temp < 1000 ) then temp = 1000 end
  if ( temp > 25000 ) then temp = 25000 end

  redshift.temp = temp
  awful.spawn("redshift -x")
  awful.spawn("redshift -O " .. redshift.temp)
  redshift.is_on = true
end

function redshift:increase_temp(value)
  redshift:set_temp(redshift.temp + value)
end

function redshift:decrease_temp(value)
  redshift:set_temp(redshift.temp - value)
end

function redshift:toggle()
  if redshift.is_on then
    awful.spawn("redshift -x")
  else
    awful.spawn("redshift -O " .. redshift.temp)
  end
  redshift.is_on = not redshift.is_on
end

redshift.widget:connect_signal("button::press",
  function(_, _, _, button)
    if (button == 4) then -- Scroll up
      redshift:increase_temp(100)
    elseif (button == 5) then -- Scroll down
      redshift:decrease_temp(100)
    elseif (button == 1) then -- Left click
      redshift:toggle()
    end
    redshift.widget:update()
  end
)

redshift.widget:update()

return redshift.widget