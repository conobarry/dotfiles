
-- Awesome modules
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local dpi = beautiful.xresources.apply_dpi

local inspect = require("lua_modules.inspect")

local markup = require("pango_markup")

-- local icon_switching_widget = require("widgets.icon_switching_widget")

-- local volume = icon_switching_widget {
--   value = 0,
--   update = update,
-- }

local now_playing = {
  bg_normal = beautiful.bar.bg_normal,
  fg_normal = beautiful.bar.fg_normal,
  font = beautiful.bar.font,
}

-- Yes, these commands would be a lot simpler with pulsemixer, but amixer seems to be faster!
now_playing.get_playing_cmd = "playerctl status"
now_playing.vol_up_cmd = string.format("amixer -q set Master %d%%+", now_playing.change_value)
now_playing.vol_down_cmd = string.format("amixer -q set Master %d%%-", now_playing.change_value)
now_playing.toggle_mute_cmd = "amixer -q set Master toggle"

local function to_icon_path(filename)
  return "/home/conor/convert/svgs/" .. filename .. ".png"
end
now_playing.icons = {
  low    = to_icon_path("audio-volume-low"),
  medium = to_icon_path("audio-volume-medium"),
  high   = to_icon_path("audio-volume-high"),
  muted  = to_icon_path("audio-volume-muted")
}

-- volume.textbox.format = "vol"
-- volume.imagebox.image = icons.high
-- volume.icon_padding.margins = beautiful.dpi(2)


function now_playing:increase()
  awful.spawn(self.vol_up_cmd)
  naughty.notify({text = "Vol up"})
  self.value = self.value + self.change_value
  self:update_values()
end


function now_playing:decrease()
  awful.spawn(self.vol_down_cmd)
  naughty.notify({text = "Vol down"})
  self.value = self.value - self.change_value
  self:update_values()
end


function now_playing:toggle_mute()
  awful.spawn(self.toggle_mute_cmd)
  naughty.notify({text = "Toggle mute"})
  self.is_muted = not self.is_muted
  self:update_values()
end


function now_playing:update_values()

  self.markup.text = self.is_muted and "M" or self.value
  self.textbox.markup = self.markup:generate()

  local image = self.icons.muted

  if self.is_muted then image = self.icons.muted
  elseif self.value < 33 then image = self.icons.low
  elseif self.value < 66 then image = self.icons.medium
  else image = self.icons.high end

  self.imagebox.image = image

end


function now_playing:fetch_levels()
  awful.spawn.easy_async_with_shell(self.get_playing_cmd,
    function (stdout)

      local value = string.match(stdout, "%d+")
      local is_muted = string.match(stdout, "%a+")

      value = tonumber(value)
      is_muted = ( is_muted == "off" )

      self.value = value
      self.is_muted = is_muted

      self:update_values()

    end)
end


function now_playing:new(args)

  args = args or {}

  local instance = {}
  setmetatable(instance, self)
  self.__index = self

  instance.markup = markup({
    text = "hello",
    foreground = instance.fg_normal,
    font_desc = instance.font
  })

  instance.background = wibox.widget {
    widget = wibox.container.background,
    bg = instance.bg_normal,
  }

  instance.textbox = wibox.widget {
    widget = wibox.widget.textbox,
    visible = false
  }

  instance.imagebox = wibox.widget {
    widget = wibox.widget.imagebox,
    image = self.icons.high
  }

  instance.widget = wibox.widget {
    widget = instance.background,
    {
      widget = wibox.container.margin,
      left = beautiful.bar.widget_padding,
      right = beautiful.bar.widget_padding,
      {
        layout = wibox.layout.stack,
        {
          widget = wibox.container.margin,
          margins = beautiful.dpi(2),
          {
            widget = instance.imagebox,
          }
        },
        {
          widget = instance.textbox,
        }
      }
    }
  }

  instance.widget:connect_signal("mouse::enter",
    function(widget)
      instance:fetch_levels()
      instance.imagebox.visible = false
      instance.textbox.markup = instance.markup:generate()
      instance.textbox.visible = true
      instance.background.bg = instance.bg_focus
    end
  )

  instance.widget:connect_signal("mouse::leave",
    function()
      instance:fetch_levels()
      instance.imagebox.visible = true
      instance.textbox.visible = false
      instance.background.bg = instance.bg_normal
    end
  )

  instance.widget:connect_signal("button::press",
    function(_, _, _, button)
      if (button == 4) then
        instance:increase()
      elseif (button == 5) then
        instance:decrease()
      elseif (button == 1) then
        instance:toggle_mute()
      end
      instance:update_values()
    end
  )

  instance:fetch_levels()

  return instance.widget

end

-- volume.widget:update()

return setmetatable(now_playing,
  {
    __call = function(_, ...) return now_playing:new(...) end
  }
)
