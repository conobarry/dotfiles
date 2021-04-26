
local awful = require("awful")
local beautiful = require("beautiful")
local naughty = require("naughty")
local gears = require("gears")
local wibox = require("wibox")

local awesome = _G.awesome
local screen = _G.screen

local inspect = require("lua_modules.inspect")
-- local audio_popup = require("widgets.audio_popup.audio_popup")

local media_controller = {
  default_volume_change = 2,
}

media_controller.notification = naughty.notify({text = "hello"})

--[[
  amixer commands are faster than pulsemixer, but rapidly running 'amixer set Master n%+'
    consistently results in unbalanced left and right channels!
  The amixer commands are left here just in case they are needed again.
--]]
-- media_controller.get_vol_cmd = "amixer get Master | awk -F\"[][]\" '/Left:/ { gsub(\"%\",\"\"); printf \"%s %s\", $2, $4 }'"
-- media_controller.vol_raise_cmd = "amixer -q set Master %d%%+"
-- media_controller.vol_lower_cmd = "amixer -q set Master %d%%-"
-- media_controller.toggle_mute_cmd = "amixer -q set Master toggle"
media_controller.vol_raise_cmd = "pulsemixer --change-volume +%d --get-volume"
media_controller.vol_lower_cmd = "pulsemixer --change-volume -%d --get-volume"
media_controller.toggle_mute_cmd = "pulsemixer --toggle-mute --get-mute"
media_controller.get_levels_cmd = "pulsemixer --get-volume --get-mute"

media_controller.get_player_status_cmd = "playerctl status"
media_controller.play_pause_cmd = "playerctl play-pause"
media_controller.next_track_cmd = "playerctl next"
media_controller.prev_track_cmd = "playerctl previous"
media_controller.get_metadata_cmd = "playerctl metadata"

-- Sends a signal to all volume widgets to update with the given values
local function signal_volume_widget_update(values)
  awesome.emit_signal("update_volume_widgets", values)
end

-- Sends a signal to all audio popup to update with the given values
local function signal_audio_popup_update(values)
  awesome.emit_signal("update_audio_popups", values)
end

local function parse_playerctl_metadata(stdout)

  local data = {}

  local is_playing = string.match(stdout, "%a+")
  is_playing = ( is_playing == "Playing" )



end

function media_controller.fetch_volume_levels()
  awful.spawn.easy_async(media_controller.get_levels_cmd,
    function (stdout)

      local level = string.match(stdout, "%d+")
      local is_muted = string.match(stdout, "\n(%d)")

      level = tonumber(level)
      is_muted = ( tonumber(is_muted) == 1 )

      local values = {
        level = level,
        is_muted = is_muted
      }
      
      awesome.emit_signal("update_volume_widgets", values)
      
    end
  )
end

function media_controller.update_player_status()
  awful.spawn.easy_async_with_shell(media_controller.get_player_status_cmd,
    function (stdout)

      local is_playing = string.match(stdout, "%d+")
      local title = string.match(stdout, "%a+")
      local artist = ""
      local artURL = ""

      -- Art url for spotify is not correct, it's actually at:
      -- https://i.scdn.co/image/{art-address}


      local status = {
        
      }

      awesome.emit_signal("update_player_widgets", status)
    end
  )
end

-- Runs a command to raise the system volume then updates all volume widgets
function media_controller.raise_volume(value)

  -- Check that the value is a number
  value = value or media_controller.default_volume_change
  assert(type(value) == "number", "damn")

  -- Run command to raise volume
  awful.spawn.easy_async(string.format(media_controller.vol_raise_cmd, value),
    function (stdout)

      -- Get the new volume from stdout and singal volume widgets to update
      local volume = tonumber(string.match(stdout, "%d+"))
      signal_volume_widget_update({ level = volume })

    end
  )
end

-- Runs a command to lower the system volume then updates all volume widgets
function media_controller.lower_volume(value)

  -- Check that the value is a number
  value = value or media_controller.default_volume_change
  assert(type(value) == "number", "damn")

  -- Run command to lower volume
  awful.spawn.easy_async(string.format(media_controller.vol_lower_cmd, value),
    function (stdout)

      -- Get the new volume from stdout and singal volume widgets to update
      local volume = tonumber(string.match(stdout, "%d+"))
      signal_volume_widget_update({ level = volume })

    end
  )
end

function media_controller.toggle_mute()

  -- Run command to toggle mute
  awful.spawn.easy_async(media_controller.toggle_mute_cmd,
    function (stdout)

      -- Get the new volume from stdout and singal volume widgets to update
      local is_muted = string.match(stdout, "%d")

      signal_volume_widget_update(
        {
          is_muted = ( tonumber(is_muted) == 1 )
        }
      )

    end
  )
end

function media_controller.toggle_play_pause()

  local command = string.format("%s && %s && %s",
    media_controller.play_pause_cmd,
    media_controller.get_player_status_cmd,
    media_controller.get_metadata_cmd
  )

  -- Run command to toggle play/pause
  awful.spawn.easy_async(command,
    function (stdout)

      local data = parse_playerctl_metadata(stdout)

      signal_audio_popup_update(data)

    end
  )
end

function media_controller.next_track()
  awful.spawn(media_controller.next_track_cmd, false)
  media_controller.update_player_status()
end

function media_controller.previous_track()
  awful.spawn(media_controller.prev_track_cmd, false)
  media_controller.update_player_status()
end

awesome.connect_signal("media::toggle_mute", media_controller.toggle_mute)
awesome.connect_signal("media::vol_raise", media_controller.raise_volume)
awesome.connect_signal("media::vol_lower", media_controller.lower_volume)
awesome.connect_signal("media::toggle_play_pause", media_controller.toggle_play_pause)
awesome.connect_signal("media::next_track", media_controller.next_track)
awesome.connect_signal("media::prev_track", media_controller.previous_track)

return media_controller