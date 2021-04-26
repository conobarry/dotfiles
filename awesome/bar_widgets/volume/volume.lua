
-- Awesome modules
local awesome = _G.awesome
-- local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
-- local naughty = require("naughty")
-- local dpi = beautiful.xresources.apply_dpi

local inspect = require("lua_modules.inspect")
local media_controller = require("controllers.media_controller")

local markup = require("utils.pango_markup")

local volume = {
  change_value = media_controller.default_volume_change,
  max_level = 150, -- Keep to max 150 if using pulsemixer
  bg_normal = beautiful.bar.bg_normal,
  fg_normal = beautiful.bar.fg_normal,
  font = beautiful.bar.font,
  level = 0,
  is_muted = false
}

-- Yes, these commands would be a lot simpler with pulsemixer, but amixer seems to be faster!
-- volume.get_vol_cmd = "amixer get Master | awk -F\"[][]\" '/Left:/ { gsub(\"%\",\"\"); printf \"%s %s\", $2, $4 }'"
-- volume.vol_up_cmd = string.format("amixer -q set Master %d%%+", volume.change_value)
-- volume.vol_down_cmd = string.format("amixer -q set Master %d%%-", volume.change_value)
-- volume.toggle_mute_cmd = "amixer -q set Master toggle"

local function to_icon_path(filename)
  return os.getenv('HOME') .. "/.config/awesome/bar_widgets/volume/" .. filename .. ".png"
end

volume.icons = {
  low    = to_icon_path("audio-volume-low"),
  medium = to_icon_path("audio-volume-medium"),
  high   = to_icon_path("audio-volume-high"),
  muted  = to_icon_path("audio-volume-muted")
}

-- function volume:raise_volume()
--   -- awful.spawn(self.vol_up_cmd)
--   -- naughty.notify({text = "Vol up"})
--   self.level = self.level + self.change_value
--   self:update_values()
-- end


-- function volume:lower_volume()
--   -- awful.spawn(self.vol_down_cmd)
--   -- naughty.notify({text = "Vol down"})
--   self.level = self.level - self.change_value
--   self:update_values()
-- end


-- function volume:toggle_mute()
--   awful.spawn(self.toggle_mute_cmd)
--   naughty.notify({text = "Toggle mute"})
--   self.is_muted = not self.is_muted
--   self:update_values()
-- end


function volume:update_values()

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


-- function volume:fetch_levels()
--   -- awful.spawn.easy_async_with_shell(self.get_vol_cmd,
--   --   function (stdout)

--   --     local value = string.match(stdout, "%d+")
--   --     local is_muted = string.match(stdout, "%a+")

--   --     value = tonumber(value)
--   --     is_muted = ( is_muted == "off" )

--   --     self.value = value
--   --     self.is_muted = is_muted

--   --     self:update_values()

--   --   end)
  
-- end


function volume:new(args)

  args = args or {}

  local _volume = {}
  setmetatable(_volume, self)
  self.__index = self

  _volume.markup = markup({
    text = "",
    foreground = _volume.fg_normal,
    font_desc = _volume.font
  })

  _volume.background = wibox.widget {
    widget = wibox.container.background,
    bg = _volume.bg_normal,
  }

  _volume.textbox = wibox.widget {
    widget = wibox.widget.textbox,
    visible = false
  }

  _volume.imagebox = wibox.widget {
    widget = wibox.widget.imagebox,
    image = self.icons.high,
    visible = true
  }

  _volume.widget = wibox.widget {
    widget = _volume.background,
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
            widget = _volume.imagebox,
          }
        },
        {
          widget = _volume.textbox,
        }
      }
    }
  }

  _volume.widget:connect_signal("mouse::enter",
    function(widget)
      media_controller.fetch_volume_levels()
      _volume.imagebox.visible = false
      _volume.textbox.markup = _volume.markup:generate()
      _volume.textbox.visible = true
      _volume.background.bg = _volume.bg_focus
    end
  )

  _volume.widget:connect_signal("mouse::leave",
    function()
      -- _volume:fetch_levels()
      _volume.imagebox.visible = true
      _volume.textbox.visible = false
      _volume.background.bg = _volume.bg_normal
    end
  )

  _volume.widget:connect_signal("button::press",
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
      _volume:update_values()
    end
  )

  awesome.connect_signal("update_volume_widgets",
    function(values)

      -- print("updating volume widget")
      -- print("new values are: " .. inspect(values, {depth = 2}))

      if values.level then _volume.level = tonumber(values.level) end
      if values.is_muted ~= nil then _volume.is_muted = values.is_muted end

      _volume:update_values()
    end
  )

  media_controller.fetch_volume_levels()

  return _volume.widget

end

-- volume.widget:update()

return setmetatable(volume,
  {
    __call = function(_, ...) return volume:new(...) end
  }
)
