
-- Capture variables
local awesome = _G.awesome
local client = _G.client

-- Awesome libraries
local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local hotkeys_popup = require("awful.hotkeys_popup").widget
local dpi = beautiful.xresources.apply_dpi
local naughty = require("naughty")

-- Local libraries
local menu = require("widgets.menus.main_menu")
-- local prompt_popup = require("widgets.prompt_popup")
-- local alttab = require("widgets.alttab")
local media_controller = require("controllers.media_controller")

local inspect = require("lua_modules.inspect")

local global = require("configuration.global")
local modkey = global.modkey

local bindings = {
  modkey = modkey
}

-- {{{ Mouse bindings
-- mouse buttons are:
--  1. LMB
--  2. Wheel click
--  3. RMB
--  4. Scroll up
--  5. Scroll down
bindings.mouse = {

  -- Global mouse bindings apply to desktop
  global = gears.table.join(

    -- Right click to toggle main menu
    awful.button({ }, 3, function() menu:toggle() end)

    -- Scroll up to switch to next tag
    --awful.button({ }, 4, awful.tag.viewnext),

    -- Scroll down to switch to previous tag
    --awful.button({ }, 5, awful.tag.viewprev)
  ),

  -- Client mouse bindings apply to windows (clients)
  client = gears.table.join(

    -- Left click to send a
    awful.button({ }, 1, function(c) 

        -- This sends the mouse signal to the client
        c:emit_signal("request::activate", "mouse_click", {raise = true}) 
      end),

    -- Modkey and LMB moves the client
    awful.button({modkey}, 1, function(c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
      end),

    -- Modkey and right mouse button resizes the client
    awful.button({modkey}, 3, function(c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
      end)
  )
}
-- }}}

-- {{{ Keyboard bindings
bindings.keyboard = {

  -- Global key bindings apply to anywhere
  global = gears.table.join(

    -- Awesome
    awful.key({ modkey            }, "F1",  hotkeys_popup.show_help,
      {description = "show help", group = "awesome"}
    ),
    awful.key({ modkey            }, "w",   function() menu:show() end,
      {description = "show main menu", group = "awesome"}
    ),
    awful.key({ modkey, "Control" }, "r",   awesome.restart, 
      {description = "reload awesome", group = "awesome"}
    ),    
    awful.key({ modkey, "Control" }, "q",   awesome.quit, 
      {description = "quit awesome", group = "awesome"}
    ),
    awful.key({ modkey, "Control" }, "d",
      function()
        print("changing theme")
        beautiful.init(gears.filesystem.get_configuration_dir() .. "themes/compact/theme_dark.lua")
      end
    ),

    -- System
    awful.key( { } , "XF86AudioRaiseVolume",
      function ()
        -- awful.spawn("pulsemixer --change-volume +2")
        media_controller.raise_volume()
        -- naughty.notify({text = "Vol up"})
      end
    ),
    awful.key( { } , "XF86AudioLowerVolume",
      function ()
        -- awful.spawn("pulsemixer --change-volume -2")
        -- naughty.notify({text = "Vol down"})
        media_controller.lower_volume()
      end
    ),
    awful.key( { } , "XF86AudioMute",
      function ()
        -- awful.spawn("pulsemixer --toggle-mute")
        -- naughty.notify({text = "Toggle mute"})
        media_controller.toggle_mute()
      end
    ),
    awful.key( { } , "XF86AudioPlay",
      function ()
        -- awful.spawn("playerctl play-pause")
        -- naughty.notify({text = "Play/Pause"})
        media_controller.toggle_play_pause()
      end
    ),
    awful.key( { } , "XF86AudioPrev",
      function ()
        -- awful.spawn("playerctl previous")
        -- naughty.notify({text = "Previous"})
        media_controller.previous_track()
      end
    ),
    awful.key( { } , "XF86AudioNext",
      function ()
        -- awful.spawn("playerctl next")
        -- naughty.notify({text = "Next"})
        media_controller.next_track()
      end
    ),

    -- Tag
    -- awful.key({ modkey            }, "Left",    awful.tag.viewprev, 
    --   {description = "view previous", group = "tag"}
    -- ),
    -- awful.key({ modkey            }, "Right",   awful.tag.viewnext, 
    --   {description = "view next", group = "tag"}
    -- ),
    -- awful.key({ modkey            }, "Escape",  awful.tag.history.restore, 
    --   {description = "go back", group = "tag"}
    -- ),

    -- Client
    awful.key({ modkey            }, "j", 
      function()
        awful.client.focus.byidx(1)
      end,
      {description = "focus next by index", group = "client"}
    ),
    awful.key({ modkey            }, "k", function() awful.client.focus.byidx(-1) end,
      {description = "focus previous by index", group = "client"}
    ),
    awful.key({ modkey            }, "Up", 
      function()
        awful.client.focus.global_bydirection("up")
      end,
      {description = "focus up by direction", group = "client"}
    ),
    awful.key({ modkey            }, "Down",
      function()
        awful.client.focus.global_bydirection("down")
      end,
      {description = "focus down by direction", group = "client"}
    ),
    awful.key({ modkey            }, "Left",
      function()
        awful.client.focus.global_bydirection("left")
      end,
      {description = "focus left by direction", group = "client"}
    ),
    awful.key({ modkey            }, "Right",
      function()
        awful.client.focus.global_bydirection("right")
      end,
      {description = "focus right by direction", group = "client"}
    ),
    awful.key({ modkey }, "u", awful.client.urgent.jumpto, 
      {description = "jump to urgent client", group = "client"}
    ),
    awful.key({ modkey }, "Tab",
      function() awful.spawn("rofi -show-icons -show window") end,
      -- function()
      --   awful.client.focus.history.previous()
      --   if client.focus then
      --     client.focus:raise()
      --   end
      -- end,
      {description = "window switcher", group = "client"}
    ),    
    
    -- Screen
    awful.key({ modkey }, "o", function() awful.screen.focus_relative(1) end,
      {description = "focus the next screen", group = "screen"}
    ),
    -- awful.key({ modkey, "Control" }, "h", function() awful.screen.focus_relative(-1) end,
    --   {description = "focus the previous screen", group = "screen"}
    -- ),  

    -- Launch
    awful.key({ modkey }, "Return",
      function()
        awful.spawn(global.terminal)
      end,
      {description = "open a terminal", group = "launch"}
    ),
    awful.key({ modkey, "Shift" }, "Return",
      function()
        local c = awful.spawn("kitty --name=kitty-floating", {
          floating = true,
          placement = awful.placement.centered,
          -- width = dpi(1000),
          -- height = dpi(600),
        })
      end,
      {description = "quick terminal", group = "launch"} 
    ),
    awful.key({ modkey }, "r",
      --function() awful.screen.focused().mypromptbox:run() end,
      function() 
        -- prompt_popup:toggle()
      end,
      {description = "run prompt", group = "launch"}
    ),
    awful.key({ modkey }, "d",
      --function() awful.screen.focused().mypromptbox:run() end,
      function() 
        -- alttab.switch(1, "Mod1", "Alt_L", "Shift", "Tab")
      end,
      {description = "run prompt", group = "launch"}
    ),
    awful.key({ modkey }, "space",
      function() awful.spawn("rofi -show run") end,
      {description = "run rofi", group = "launch"}
    ),
    awful.key({ modkey }, "e",
      function() awful.spawn(global.file_manager) end,
      {description = "file explorer", group = "launch"}
    ),
    awful.key({ modkey }, "b",
      function() awful.spawn.with_shell(global.browser) end,
      {description = "web browser", group = "launch"}
    ),
    awful.key({ "Control", "Shift" }, "Escape",
      function() awful.spawn.with_shell("ksysguard") end,
      {description = "task manager", group = "launch"}
    ),

    -- Layout    
    awful.key({ modkey }, "l", 
      -- Increase master width factor
      function() awful.tag.incmwfact(0.05) end,
      {description = "increase master width", group = "layout"}
    ),
    awful.key({ modkey }, "h", 
      function() awful.tag.incmwfact(-0.05) end,
      {description = "decrease master width", group = "layout"}
    ),
    awful.key({ modkey, "Shift"   }, "j",
      function() awful.client.swap.byidx(1) end,
      {description = "swap with next client by index", group = "client"}
    ), 
    awful.key({ modkey, "Shift"   }, "k",
      function() awful.client.swap.byidx(-1) end,
      {description = "swap with previous client by index", group = "client"}
    ),
    awful.key({ modkey, "Control" }, "h",
      function() awful.tag.incnmaster(1, nil, true) end,
      {description = "increase the number of master clients", group = "layout"}
    ),
    awful.key({ modkey, "Control" }, "l",
      function() awful.tag.incnmaster(-1, nil, true) end,
      {description = "decrease the number of master clients", group = "layout"}
    ),
    -- awful.key({ modkey, "Control" }, "h",
    --   function() awful.tag.incncol(1, nil, true) end,
    --   {description = "increase the number of columns", group = "layout"}
    -- ),
    -- awful.key({ modkey, "Control" }, "l",
    --   function() awful.tag.incncol(-1, nil, true) end,
    --   {description = "decrease the number of columns", group = "layout"}
    -- ),
    awful.key({ modkey, "Control" }, "n",
      function()
        local c = awful.client.restore()
        -- Focus restored client
        if c then
          c:emit_signal("request::activate", "key.unminimize", {raise = true})
        end
      end,
      {description = "restore minimized", group = "client"}
    )
    -- awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
    --           {description = "select next", group = "layout"}),
    -- awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
    --           {description = "select previous", group = "layout"}),
      
    -- -- Menubar
    -- awful.key({ modkey }, "p", function() menubar.show() end,
    --           {description = "show the menubar", group = "launcher"}),    
    
    -- Volume
    -- awful.key({ "Mod4" }, "Up",
    --   function() 
    --     awful.util.spawn("amixer set Master 2%+")
    --     volume_widget:update()
    --   end,
    --   {description = "Increase the volume", group = "media"}
    -- ),
    -- awful.key({ "Mod4" }, "Down",
    --   function() 
    --     awful.util.spawn("amixer set Master 2%-")
    --     volume_widget:update()
    --   end,
    --   {description = "Decrease the volume", group = "media"}
    -- )
  ),

  -- Client key bindings apply to windows (clients)
  client = gears.table.join(
    -- awful.key({ modkey }, "f",
    --   function(c)
    --     c.fullscreen = not c.fullscreen
    --     c:raise()
    --   end,
    --   {description = "toggle fullscreen", group = "client"}
    -- ),
    awful.key({ modkey, "Shift" }, "h",
      -- Make this client a master
      function(c)
        print(inspect(awful.tag.layout))
        --print(inspect(c))
        --awful.client.setmaster(c)
      end,
      --function() awful.tag.incnmaster(1, nil, true) end,
      {description = "make client a master", group = "layout"}
    ),
    awful.key({ modkey }, "q",
      function(c) c:kill() end,
      {description = "close", group = "client"}
    ),
    awful.key({ modkey }, "f", awful.client.floating.toggle,
      {description = "toggle floating", group = "client"}
    ),
    -- awful.key({ modkey, "Shift" }, "f", awful.client.fullscreen,
    --   {description = "toggle fullscreen", group = "client"}
    -- ),
    -- awful.key({ modkey, "Control" }, "Return",
    --   function(c) c:swap(awful.client.getmaster()) end,
    --   {description = "move to master", group = "client"}
    -- ),
    awful.key( { modkey, "Shift" }, "o",
      function(c) c:move_to_screen() end,
      {description = "move to next screen", group = "client"}
    ),
    awful.key({ modkey }, "t",
      function(c) c.ontop = not c.ontop end,
      {description = "toggle keep on top", group = "client"}
    ),
    awful.key({ modkey }, "n",
      function(c)
        -- The client currently has the input focus, so it cannot be
        -- minimized, since minimized clients can't have the focus.
        c.minimized = true
      end,
      {description = "minimize", group = "client"}
    ),
    awful.key({ modkey }, "m",
      function(c)
        c.maximized = not c.maximized
        c:raise()
      end,
      {description = "(un)maximize", group = "client"}
    ),
    -- awful.key({ modkey, "Control"}, "m",
    --   function(c)
    --     c.maximized_vertical = not c.maximized_vertical
    --     c:raise()
    --   end,
    --   {description = "(un)maximize vertically", group = "client"}
    -- ),
    -- awful.key({ modkey, "Shift"}, "m",
    --   function(c)
    --     c.maximized_horizontal = not c.maximized_horizontal
    --     c:raise()
    --   end,
    --   {description = "(un)maximize horizontally", group = "client"}
    -- ),
    awful.key({ modkey }, "c",
      function(c)
        if not c.floating then
          c.floating = true
        end
        awful.placement.align(c, { position = "centered" })
      end,
      {description = "float and center", group = "client"}
    )
  )
}
-- }}}

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
  bindings.keyboard.global = gears.table.join(bindings.keyboard.global,
    -- View tag only.
    awful.key({ modkey }, "#" .. i + 9,
      function()
        local screen = awful.screen.focused()
        
        -- for s in _G.screen do
          local tag = awful.tag.find_by_name(screen, tostring(i))
          if tag then
            tag:view_only()
          end
        -- end
      end,
      {description = "view tag #" .. i, group = "tag"}
    ),
    -- Toggle tag display.
    awful.key({ modkey, "Control" }, "#" .. i + 9,
      -- function()
      --   -- local screen = awful.screen.focused()
      --   -- local tag = screen.tags[i]
      --   -- if tag then
      --   --   awful.tag.viewtoggle(tag)
      --   -- end
      --   --local this_tag = client.tag
      --   local this_tag = client.focus and client.focus.first_tag or nil
      --   for s in _G.screen do
      --     local tag = awful.tag.find_by_name(s, tostring(i))
      --     if tag then
      --       this_tag.swap(tag)
      --     end
      --   end
      -- end,
      function ()
        local from = client.focus and client.focus.first_tag or nil
        local to = {}

        local screen = awful.screen.focused()

        -- for s in _G.screen do
          local tag = awful.tag.find_by_name(screen, tostring(i))
          if tag then
            to = tag
          end
        -- end

        if to then
            local other_clients = to:clients()
            for i, c in ipairs(from:clients()) do
                awful.client.movetotag(to, c)
            end
            for i, c in ipairs(other_clients) do
                awful.client.movetotag(from, c)
            end
        end
     end,
      {description = "swap clients with tag #" .. i, group = "tag"}
    ),
    -- Move client to tag.
    awful.key({ modkey, "Shift" }, "#" .. i + 9,
      function()
        -- if client.focus then
        --   local tag = client.focus.screen.tags[i]
        --   if tag then
        --     client.focus:move_to_tag(tag)
        --   end
        -- end

        local screen = awful.screen.focused()

        -- for s in _G.screen do
          local tag = awful.tag.find_by_name(screen, tostring(i))
          if tag then
            client.focus:move_to_tag(tag)
          end
        -- end
      end,
      {description = "move focused client to tag #" .. i, group = "tag"}
    ),
    -- Toggle tag on focused client.
    awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
      function()
        if client.focus then
          local tag = client.focus.screen.tags[i]
          if tag then
            client.focus:toggle_tag(tag)
          end
        end
      end,
      {description = "toggle focused client on tag #" .. i, group = "tag"}
    )
  )
end

-- Mouse bindings for taglist
bindings.taglist_mouse = gears.table.join(
  awful.button({        }, 1,
    function(t)
      t:view_only() 
    end
  ),
  awful.button({ modkey }, 1, 
    function(t)
      if client.focus then
        client.focus:move_to_tag(t)
      end
    end
  ),
  awful.button({        }, 3, 
    awful.tag.viewtoggle
  ),
  awful.button({ modkey }, 3, 
    function(t)
      if client.focus then
        client.focus:toggle_tag(t)
      end
    end
  ),
  awful.button({        }, 4, 
    function(t)
      awful.tag.viewnext(t.screen)
    end
  ),
  awful.button({        }, 5,
    function(t)
      awful.tag.viewprev(t.screen)
    end
  )
)

-- Mouse bindings for tasklist
bindings.tasklist_mouse = gears.table.join(
  awful.button({ }, 1,
    function(c)
      if c == client.focus then
        c.minimized = true
      else
        c:emit_signal("request::activate", "tasklist", {raise = true})
      end
    end
  ),
  awful.button({ }, 3,
    function()
      awful.menu.client_list({theme = {width = 250}})
    end
  ),
  awful.button({ }, 4,
    function()
      awful.client.focus.byidx(1)
    end
  ),
  awful.button({ }, 5,
    function()
      awful.client.focus.byidx(-1)
    end
  )
)

-- Button bindings for the titlebar
bindings.titlebar_mouse = gears.table.join(
  awful.button({}, 1,
    function(titlebar)
      --print(require("lua_modules.inspect")(c, {depth = 2}))
      titlebar.client:emit_signal("request::activate", "titlebar", {raise = true})
      awful.mouse.client.move(client)
    end
  ),
  awful.button({}, 3,
    function()
      client:emit_signal("request::activate", "titlebar", {raise = true})
      awful.mouse.client.resize(client)
    end
  )
)

return bindings