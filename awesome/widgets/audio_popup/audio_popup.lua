
local awful = require("awful")
local beautiful = require("beautiful")
local naughty = require("naughty")
local gears = require("gears")
local wibox = require("wibox")

local awesome = _G.awesome
local screen = _G.screen

local inspect = require("lua_modules.inspect")

local audio_popup = {
  title = "Title"
}

local function to_icon_path(filename)
  return os.getenv("HOME") .. "/.config/awesome/widgets/audio_popup/" .. filename .. ".png"
end

local icons = {
  light = {
    play = to_icon_path("light/media-playback-start-large"),
    pause = to_icon_path("light/media-playback-pause-large"),
    next = to_icon_path("light/media-skip-forward-large"),
    previous = to_icon_path("light/media-skip-backward-large"),
  },
  dark = {
    play = to_icon_path("dark/media-playback-start-large"),
    pause = to_icon_path("dark/media-playback-pause-large"),
    next = to_icon_path("dark/media-skip-forward-large"),
    previous = to_icon_path("dark/media-skip-backward-large"),
  }
}

local function make_scrolling_textbox(textbox)

  -- textbox.align = "center"

  local ellipsized_text = wibox.widget {
    widget = textbox,
    ellipsize = "end"
  }

  local scrollbox = wibox.widget {
    layout = wibox.container.scroll.horizontal,
    step_function = wibox.container.scroll.step_functions.linear_increase,
    textbox
  }

  scrollbox:set_fps(60)
  scrollbox:set_speed(40)
  scrollbox:set_extra_space(20)

  local container = wibox.widget {
    layout = wibox.layout.align.horizontal,
    expand = "outside",
    nil,
    ellipsized_text
  }

  -- container.second = ellipsized_text

  container:connect_signal("mouse::enter",
    function ()
      container.second = scrollbox
      scrollbox:continue()
    end
  )

  container:connect_signal("mouse::leave",
    function ()
      container.second = ellipsized_text
      scrollbox:reset_scrolling()
      scrollbox:pause()
    end
  )

  scrollbox:pause()

  return container
end

local function make_imagebox_button(imagebox, icon, alt_icon, callback)

  local button = wibox.widget {
    widget = wibox.container.background,
    shape = gears.shape.rectangle,
    bg = beautiful.bar.bg_normal,
    forced_height = 40,
    forced_width = 40,
    {
      widget = wibox.container.place,
      imagebox
    }
  }

  button:connect_signal("mouse::enter",
    function ()
      button.bg = beautiful.bg_focus
      imagebox.image = alt_icon
    end
  )

  button:connect_signal("mouse::leave",
    function ()
      button.bg = beautiful.bar.bg_normal
      imagebox.image = icon
    end
  )

  button:connect_signal("button::press",
    function (_, _, _, mouse_button)
      if ( mouse_button == 1 ) then
        button.bg = beautiful.bg_normal
        imagebox.icon = alt_icon
        callback()
      end
    end
  )

  button:connect_signal("button::release",
    function (_, _, _, mouse_button)
      if ( mouse_button == 1 ) then
        button.bg = beautiful.bar.bg_normal
        imagebox.image = icon
      end
    end
  )

  button:connect_signal("button::down",
    callback
  )

  return button

end

-- Create the wibox
audio_popup.wibox = wibox {
  ontop = true,
  fg = beautiful.fg_normal,
  bg = beautiful.bar.bg_normal,
  border_color = "#000000",
  border_width = 1,
  type = "popup_menu",
  screen = 1,
  width = 400,
  height = 130,
  x = screen.primary.geometry.x + beautiful.useless_gap,
  y = screen.primary.geometry.y + beautiful.bar.height + beautiful.useless_gap,
  visible = true,
}

audio_popup.grid_layout = wibox.widget {
  layout = wibox.layout.grid,
  expand = true,
  forced_num_rows = 3,
  forced_num_cols = 3,
  vertical_homogeneous = false,
}

audio_popup.title_textbox = wibox.widget {
  widget = wibox.widget.textbox,
  text = audio_popup.title,
  --text = "People Ain't No Good - 2011 Remastered Version"
}

audio_popup.artist_textbox = wibox.widget {
  widget = wibox.widget.textbox,
  text = "Nick Cave & The Bad Seeds",
}

audio_popup.album_textbox = wibox.widget {
  widget = wibox.widget.textbox,
  text = "The Boatman's Call (2011 Remastered Version)"
}

audio_popup.album_art_imagebox = wibox.widget {
  widget = wibox.widget.imagebox,
  image = "/home/conor/.config/awesome/widgets/audio_popup/placeholder-album-art.jpg",
  forced_height = 150,
}

audio_popup.play_pause_icon_imagebox = wibox.widget {
  widget = wibox.widget.imagebox,
  image = icons.dark.pause,
}

audio_popup.prev_track_icon_imagebox = wibox.widget {
  widget = wibox.widget.imagebox,
  image = icons.dark.previous
}

audio_popup.next_track_icon_imagebox = wibox.widget {
  widget = wibox.widget.imagebox,
  image = icons.dark.next
}

-- audio_popup.grid_layout:add_widget_at(
--   make_scrolling_textbox(audio_popup.title_textbox), 1, 1, 1, 3
-- )

-- audio_popup.grid_layout:add_widget_at(
--   make_scrolling_textbox(audio_popup.artist_textbox), 2, 1, 1, 3
-- )

-- audio_popup.grid_layout:add_widget_at(
--   audio_popup.prev_track_icon_imagebox, 3, 1
-- )

-- audio_popup.grid_layout:add_widget_at(
--   audio_popup.play_pause_icon_imagebox, 3, 2
-- )

-- audio_popup.grid_layout:add_widget_at(
--   audio_popup.next_track_icon_imagebox, 3, 3
-- )

audio_popup.wibox.widget = wibox.widget {
  layout = wibox.container.margin,
  margins = 5,
  {
    layout = wibox.layout.align.horizontal,
    spacing = 5,
    {
      widget = wibox.container.margin,
      right = 5,
      audio_popup.album_art_imagebox
    },
    -- audio_popup.grid_layout
    {
      layout = wibox.layout.align.vertical,
      nil,
      {
        layout = wibox.layout.ratio.vertical,
        inner_fill_strategy = "center",
        spacing = 0,
        make_scrolling_textbox(audio_popup.title_textbox),
        make_scrolling_textbox(audio_popup.artist_textbox),
        make_scrolling_textbox(audio_popup.album_textbox)
      },
      {
        layout = wibox.layout.align.horizontal,
        expand = "outside",
        nil,
        {
          layout = wibox.layout.ratio.horizontal,
          inner_fill_strategy = "left",
          spacing = 10,
          make_imagebox_button(
            audio_popup.prev_track_icon_imagebox,
            icons.dark.previous,
            icons.light.previous,
            function() awesome.emit_signal("media::prev_track") end
          ),
          make_imagebox_button(
            audio_popup.play_pause_icon_imagebox,
            icons.dark.pause,
            icons.light.pause,
            function() awesome.emit_signal("media::toggle_play_pause") end
          ),
          make_imagebox_button(
            audio_popup.next_track_icon_imagebox,
            icons.dark.next,
            icons.light.next,
            function() awesome.emit_signal("media::next_track") end
          )
        }
      }
    }
  }
}

audio_popup.wibox:connect_signal("button::press",
  function (_, _, _, button)
    if (button == 3) then
      audio_popup.wibox.visible = false
    end
  end
)

awesome.connect_signal("update_audio_popups",
  function (value)
    -- audio_popup.title = value.title
  end
)

-- audio_popup.wibox:buttons({
--   awful.button({ }, 2, function() audio_popup.wibox.visible = false end)
-- })

return audio_popup