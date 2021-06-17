
-- Awesome modules
local awesome = _G.awesome
local wibox = require("wibox")
local beautiful = require("beautiful")
local awful = require("awful")

local inspect = require("lua_modules.inspect")
local media_controller = require("controllers.media_controller")

local markup = require("utils.pango_markup")

local battery = {
  change_value = media_controller.default_volume_change,
  max_level = 150, -- Keep to max 150 if using pulsemixer
  bg_normal = beautiful.bar.bg_normal,
  fg_normal = beautiful.bar.fg_normal,
  font = beautiful.bar.font,
  level = 0,
  is_muted = false
}

local command = 'bash -c "cat /sys/class/power_supply/BAT0/capacity"'

battery.watch = awful.widget.watch(command, 2,
  function(widget, stdout)
    widget.markup = string.format("<span font='%s' foreground='%s'>%3d%%</span>", beautiful.bar.font, beautiful.bar.fg_black, stdout)
  end
)

local function to_icon_path(filename)
  return os.getenv('HOME') .. "/.config/awesome/bar_widgets/battery/" .. filename .. ".png"
end

battery.icons = {
  low    = to_icon_path("audio-volume-low"),
  medium = to_icon_path("audio-volume-medium"),
  high   = to_icon_path("audio-volume-high"),
  muted  = to_icon_path("audio-volume-muted")
}

function battery:update_values()

  -- print(tostring(self.is_muted) .. " " .. tostring(self.level))
  
  self.markup.text = self.is_muted and "M" or self.level .. "%"
  self.textbox.markup = self.markup:generate()

  local image = self.icons.muted

  if self.is_muted then image = self.icons.muted
  elseif self.level < 33 then image = self.icons.low
  elseif self.level < 66 then image = self.icons.medium
  else image = self.icons.high end

  self.imagebox.image = image

end


function battery:new(args)

  args = args or {}

  local _battery = {}
  setmetatable(_battery, self)
  self.__index = self

  _battery.markup = markup({
    text = "",
    foreground = _battery.fg_normal,
    font_desc = _battery.font
  })

  _battery.background = wibox.widget {
    widget = wibox.container.background,
    bg = _battery.bg_normal,
  }

  _battery.textbox = wibox.widget {
    widget = wibox.widget.textbox,
    visible = false
  }

  _battery.imagebox = wibox.widget {
    widget = wibox.widget.imagebox,
    image = self.icons.high,
    visible = true
  }

  _battery.widget = wibox.widget {
    widget = _battery.background,
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
            widget = _battery.imagebox,
          }
        },
        {
          widget = _battery.textbox,
        }
      }
    }
  }

  _battery.widget:connect_signal("mouse::enter",
    function(widget)
      media_controller.fetch_volume_levels()
      _battery.imagebox.visible = false
      _battery.textbox.markup = _battery.markup:generate()
      _battery.textbox.visible = true
      _battery.background.bg = _battery.bg_focus
    end
  )

  _battery.widget:connect_signal("mouse::leave",
    function()
      -- _volume:fetch_levels()
      _battery.imagebox.visible = true
      _battery.textbox.visible = false
      _battery.background.bg = _battery.bg_normal
    end
  )

  _battery.widget:connect_signal("button::press",
    function(_, _, _, button)
      if (button == 4) then
        print("scroll up")
        -- _volume:raise_volume()
        media_controller.raise_volume(self.change_value)
        -- awesome.emit_signal("media::vol_up")
      elseif (button == 5) then
        print("scroll down")
        -- _volume:lower_volume()
        media_controller.lower_volume(self.change_value)
        -- awesome.emit_signal("media::vol_down")
      elseif (button == 2) then
        -- _volume:toggle_mute()
        media_controller.toggle_mute()
      end
      _battery:update_values()
    end
  )

  awesome.connect_signal("update_volume_widgets",
    function(values)

      -- print("updating volume widget")
      -- print("new values are: " .. inspect(values, {depth = 2}))

      if values.level then _battery.level = tonumber(values.level) end
      if values.is_muted ~= nil then _battery.is_muted = values.is_muted end

      _battery:update_values()
    end
  )

  media_controller.fetch_volume_levels()

  return _battery.widget

end

-- volume.widget:update()

return setmetatable(battery,
  {
    __call = function(_, ...) return battery:new(...) end
  }
)
