-------------------------------------------------
-- Volume Widget for Awesome Window Manager
-- Shows the current volume level
-- More details could be found here:
-- https://github.com/streetturtle/awesome-wm-widgets/tree/master/volume-widget

-- @author Pavel Makhov, Aurélien Lajoie
-- @copyright 2018 Pavel Makhov
-------------------------------------------------

local mouse = _G.mouse

local wibox = require("wibox")
local watch = require("awful.widget.watch")
local spawn = require("awful.spawn")
local naughty = require("naughty")
local gfs = require("gears.filesystem")
local debug = require("gears.debug")
local dpi = require("beautiful").xresources.apply_dpi

local PATH_TO_ICONS = "/usr/share/icons/Papirus/16x16@2x/panel/"
local GET_VOLUME_CMD = "pulsemixer --get-volume --get-mute"

local icons = {
  low = "audio-volume-low",
  medium = "audio-volume-medium",
  high = "audio-volume-high",
  muted = "audio-volume-muted"
}

local volume_icon_name = icons.high

local volume = {
  device = "",
  display_notification = true,
  notification = nil,
  delta = 5
}

function volume:toggle()
  volume:_cmd("pulsemixer --toggle-mute")
end

function volume:raise()
  volume:_cmd("pulsemixer --change-volume +" .. volume.delta .. "--max-volume 100")
end

function volume:lower()
  volume:_cmd("pulsemixer --change-volume -" .. volume.delta .. "--max-volume 100")
end

--{{{ Icon and notification update

--------------------------------------------------
--  Set the icon and return the message to display
--  base on sound level and mute
--------------------------------------------------
local function parse_output(stdout)

  local c, is_muted = string.match(stdout, "(%d+)%s%d+%c+(%d)")

  --debug.print_error("hello, world")

  -- if is_muted then
  --   volume_icon_name = icons.muted
  --   return level .. '% <span color="red"><b>Mute</b></span>'
  -- end

  c = tonumber(c)

  if (c >= 0 and c < 25) then
    volume_icon_name = icons.low
  elseif (c < 50) then
    volume_icon_name = icons.low
  elseif (c < 75) then
    volume_icon_name = icons.medium
  else
    volume_icon_name = icons.high
  end
  return c .. "%"
end

--------------------------------------------------------
--Update the icon and the notification if needed
--------------------------------------------------------
local function update_graphic(widget, stdout, _, _, _)
  local txt = parse_output(stdout)
  widget.image = PATH_TO_ICONS .. volume_icon_name .. ".svg"
  if volume.display_notification then
    volume.notification.iconbox.image = PATH_TO_ICONS .. volume_icon_name .. ".svg"
    naughty.replace_text(volume.notification, "Volume", txt)
  end
end

local function notif(msg, keep)
  if volume.display_notification then
    naughty.destroy(volume.notification)
    volume.notification =
      naughty.notify {
      text = msg,
      icon = PATH_TO_ICONS .. volume_icon_name .. ".svg",
      icon_size = dpi(16),
      title = "Volume",
      position = volume.position,
      timeout = keep and 0 or 2,
      hover_timeout = 0.5,
      width = 200,
      screen = mouse.screen
    }
  end
end

--}}}

local function worker(args)
  --{{{ Args
  local args = args or {}

  local volume_audio_controller = args.volume_audio_controller or "pulse"
  volume.display_notification = args.display_notification or false
  volume.position = args.notification_position or "top_right"

  -- if volume_audio_controller == "pulse" then
  --   volume.device = "-D pulse"
  -- end

  volume.delta = args.delta or 5
  GET_VOLUME_CMD = "pulsemixer --get-volume --get-mute"

  --}}}

  --{{{ Check for icon path
  if not gfs.dir_readable(PATH_TO_ICONS) then
    naughty.notify {
      title = "Volume Widget",
      text = "Folder with icons doesn't exist: " .. PATH_TO_ICONS,
      preset = naughty.config.presets.critical
    }
    return
  end
  --}}}

  --{{{ Widget creation
  volume.widget =
    wibox.widget {
    {
      id = "icon",
      image = PATH_TO_ICONS .. "audio-volume-muted.svg",
      resize = false,
      widget = wibox.widget.imagebox
    },
    layout = wibox.container.margin(_, _, _, 3),
    set_image = function(self, path)
      self.icon.image = path
    end
  }
  --}}}

  --{{{ Spawn functions
  function volume:_cmd(cmd)
    notif("")
    spawn.easy_async(
      cmd,
      function(stdout, stderr, exitreason, exitcode)
        update_graphic(volume.widget, stdout, stderr, exitreason, exitcode)
      end
    )
  end

  local function show()
    spawn.easy_async(
      GET_VOLUME_CMD,
      function(stdout, _, _, _)
        local txt = parse_output(stdout)
        notif(txt, true)
      end
    )
  end
  --}}}

  --{{{ Mouse event
  --[[ allows control volume level by:
    - clicking on the widget to mute/unmute
    - scrolling when cursor is over the widget
    ]]
  volume.widget:connect_signal(
    "button::press",
    function(_, _, _, button)
      if (button == 4) then
        volume.raise()
      elseif (button == 5) then
        volume.lower()
      elseif (button == 1) then
        volume.toggle()
      end
    end
  )

  if volume.display_notification then
    volume.widget:connect_signal(
      "mouse::enter",
      function()
        show()
      end
    )

    volume.widget:connect_signal(
      "mouse::leave",
      function()
        naughty.destroy(volume.notification)
      end
    )

  end
  --}}}

  --{{{ Set initial icon
  spawn.easy_async(
    GET_VOLUME_CMD,
    function(stdout, stderr, exitreason, exitcode)
      parse_output(stdout)
      volume.widget.image = PATH_TO_ICONS .. volume_icon_name .. ".svg"
    end
  )
  --}}}

  return volume.widget
end

return setmetatable(
  volume,
  {__call = function(_, ...)
      return worker(...)
    end}
)
