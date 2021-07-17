--local widget = require "lib.awful.hotkeys_popup.widget"

local beautiful = require("beautiful")
local wibox = require("wibox")
local protected_call = require("gears.protected_call")
local inspect = require("lua_modules.inspect")

local menu_item = require("widgets.menus.context_menu_item")

local screen = _G.screen
local mouse = _G.mouse


local menu = {
  icon_size = 0,
  bg = beautiful.bar.bg_normal,
  -- item_bg_normal = beautiful.bar.bg_normal,
  -- item_bg_focus = beautiful.bg_focus,
  -- item_fg_normal = beautiful.fg_normal,
  -- item_fg_focus = beautiful.fg_focus,
  -- item_padding_left = 3,
  -- item_padding_right = 3,
  item_separation = 2,
  submenus = {},
  parent = nil,
  parent_entry = nil,
  active_submenu = nil, -- Whether the menu has a submenu that is currently active
  -- is_active = false, -- Whether the menu is currently active
  is_selected = false, -- Whether the cursor is currently over the menu
  entries = {},
  id = nil
}

menu.item_type = menu_item.item_type

menu.__index = menu


function menu:is_under_mouse()

  local wibox_under_mouse = mouse.current_wibox
  
  return wibox_under_mouse == self.wibox

end


-- function menu:create_item_widget(menu_item)

--   local item_widget = wibox.widget {
--     widget = wibox.container.background,
--     {
--       widget = wibox.container.margin,
--       left = self.item_padding_left,
--       right = self.item_padding_right,
--       top = self.item_separation / 2,
--       bottom = self.item_separation / 2,
--       menu_item.widget
--     }
--   }

--   if menu_item.is_selectable then

--     item_widget:connect_signal("mouse::enter", 
--       function(widget)

--         print("Widget: " .. inspect(mouse.current_widget_geometry, {depth = 1}))

--         menu_item.geometry = mouse.current_widget_geometry

--         print("Mouse entered entry")

--         widget.bg = self.item_bg_focus
--         menu_item.is_selected = true

--         if menu_item.submenu then

--           print("Entry has submenu")

--           menu_item.submenu:show()
--           self.active_submenu = menu_item.submenu

--         end

--       end
--     )

--     item_widget:connect_signal("mouse::leave",
--       function(widget)

--         print("Mouse left entry")
        
--         menu_item.is_selected = false

--         local submenu = menu_item.submenu

--         -- if this menu item has a submenu
--         if submenu then

--           print("Entry submenu is: " .. submenu.id)

--           -- If submenu is not under the cursor
--           if not submenu:is_under_mouse() then
--             widget.bg = self.item_bg_normal
--             submenu:hide()
--           end

--           -- if submenu:is_active() then print("Submenu is active") end

--           -- if not submenu:is_active() then
--           --   print("Submenu is not active")
--           --   widget.bg = self.item_bg_normal
--           --   if not submenu:is_under_mouse() then
--           --     submenu:hide()
--           --   end
            
--           -- end
--         else
--           widget.bg = self.item_bg_normal
--         end

--       end
--     )

--   end

--   return item_widget
-- end


-- -- Returns a widget representing a menu text entry
-- function menu:text_item(args)

--   local menu_item = {
--     text = args.text or args[1] or "",
--     cmd = args.cmd or args[2] or nil,
--     icon = args.icon or args[3] or nil
--   }

--   if (menu_item.cmd) then

--     menu_item.is_selectable = true 

--     if (type(menu_item.cmd) == "table") then
      
--       menu_item.submenu = menu:new({
--         items = menu_item.cmd,
--         parent = self,
--         parent_entry = menu_item
--       })

--       table.insert(self.submenus, menu_item.submenu)

--     end

--   end

--   menu_item.widget = wibox.widget {
--     widget = wibox.container.margin,
--     margins = self.item_padding,
--     {
--       layout = wibox.layout.align.horizontal,
--       {
--         widget = wibox.widget.imagebox,
--         image = menu_item.icon
--       },
--       {
--         widget = wibox.widget.textbox,
--         text = menu_item.text
--       }
--     }
--   }

--   return menu_item

-- end


-- -- A header menu item. Is not selectable
-- function menu:header_item(args)

--   local menu_item = {
--     text = args.text or args[1] or "",
--     is_selectable = false
--   }

--   menu_item.widget = wibox.widget {
--     widget = wibox.widget.textbox,
--     markup = string.format("<b>%s</b>", menu_item.text)
--     --text = args.text
--   }

--   return menu_item
-- end


-- -- A seperator menu item. Is not selectable
-- function menu:separator_item(args)

--   local menu_item = {
--     is_selectable = false
--   }

--   menu_item.widget = wibox.widget {
--     widget = wibox.widget.separator,
--     forced_height = 1,
--   }

--   return menu_item

-- end


-- function menu.entry(args)

--   if args.type then
--     local type_func = menu.entry_type[args.type]
--     if type_func then
--         return type_func(args)
--     else
--         print("Unrecognized menu item type: '"..args.type.."'")
--         return
--     end
--   else
--       return menu.entry_type.text(args)
--   end

-- end


--[[
  Public Functions
--]]

function menu:add(args)

  -- print(inspect(args, {depth = 1}))

  local item = menu_item:new(self, args)

  if item.has_submenu then

    item.submenu = menu({
      items = item.cmd,
      parent = self,
      parent_entry = item
    })

  end

  table.insert(self.entries, item)
  self.wibox.widget:add(item.widget)

end


function menu:show()

  print("Menu being shown: " .. self.id)

  -- self.is_active = true

  local parent = self.parent

  if parent then

    print("Menu has a parent: " .. parent.id)
    parent.active_submenu = self

    --print("parent entry: " .. inspect(self.parent_entry, {depth = 2}))

    local screen = mouse.screen

    print("screen geom: " .. inspect(screen.geometry, {depth = 1}))
    print("submenu width: " .. self.wibox.width)

    if parent.wibox.x + parent.wibox.width + self.wibox.width < screen.geometry.width then
      self.wibox.x = parent.wibox.x + parent.wibox.width + 1
    else
      self.wibox.x = parent.wibox.x - parent.wibox.width - 1
    end

    self.wibox.y = self.parent_entry.geometry.y + parent.wibox.y

  else

    self.wibox.x = mouse.coords().x - 2
    self.wibox.y = mouse.coords().y - 2

  end
  
  self.wibox.visible = true

end


function menu:hide()

  -- self.is_active = false

  if self.parent and self.parent.active_submenu then
    self.parent.active_submenu = nil
  end

  if self.active_submenu then
    self.active_submenu:hide()
    self.active_submenu = nil
  end

  for _, entry in pairs(self.entries) do
    entry.bg = self.item_bg_normal
  end

  self.wibox.visible = false
  
end


function menu:get_root()
  if self.parent then
    return self.parent:get_root()
  else
    return self
  end
end


function menu:is_active()

  local is_active = false

  if self.is_selected then
    is_active = true
  elseif self.parent_entry and self.parent_entry.is_selected then
    is_active = true
  end

  return is_active

end


function menu:toggle()
  if self.wibox.visible then
    self:hide()
  else
    self:show()
  end
end


function menu:new(args)

  args = args or {}

  local items = args.items or {}
  
  if args.data then
    for k, v in pairs(args.data) do
      self.k = v
    end
  end

  local _menu = {
    parent = args.parent or nil,
    parent_entry = args.parent_entry or nil,
    active_submenu = nil,
    id = math.random(0, 100)
  }

  setmetatable(_menu, menu)

  local current_screen = screen.primary

  -- Create the wibox
  _menu.wibox = wibox {
    ontop = true,
    fg = beautiful.fg_normal,
    bg = beautiful.bar.bg_normal,
    border_color = "#000000",
    border_width = 1,
    type = "popup_menu",
    screen = current_screen,
    width = 100,
    height = 200,
    x = current_screen.geometry.x + beautiful.bar.margin,
    y = current_screen.geometry.y + beautiful.bar.margin,
    visible = false,
  }

  _menu.wibox.widget = wibox.widget {
    layout = wibox.layout.fixed.vertical,
    spacing = 0,
    fill_space = false,
  }

  -- Add all items
  for _, item in pairs(items) do
    _menu:add(item)
  end
      
  -- if args.items then
  --     for _, item in pairs(args.items) do _menu:add(item) end
  -- end

  -- _menu.widget:add(wibox.widget {
  --   widget = wibox.widget.textbox,
  --   text = "hello"
  -- })

  -- _menu:setup(widgets)

  _menu.wibox:connect_signal("mouse::enter", 
    function()

      print("Mouse entered menu: " .. _menu.id)

      -- _menu.is_active = true
      _menu.is_selected = true

      if _menu.parent then
        _menu.parent.active_submenu = _menu
      end
    end
  )

  _menu.wibox:connect_signal("mouse::leave", 
    function()
      
      print("Mouse leaving menu: " .. _menu.id)

      _menu.is_selected = false

      if _menu.active_submenu then

        print("Active submenu = " .. _menu.active_submenu.id)

        if not _menu.active_submenu:is_under_mouse() then
          _menu:hide()
        end

      else

        if _menu.parent and not _menu.parent:is_under_mouse() then
          _menu:get_root():hide()
        end

        _menu:hide()
      end

      print(tostring(_menu:is_under_mouse()))

      
      
      -- -- If there is not an active submenu
      -- if not _menu.active_submenu then

      --   print("no active submenu")
      --   _menu:hide()

      --   -- If this menu has a parent menu
      --   if _menu.parent then

      --     -- If this menu is not under the cursor
      --     if not _menu.is_selected then

      --       print("not under mouse")
      --       _menu.parent:hide()

      --     end
      --   end
      -- end
    end
  )

  print("Menu created: " .. _menu.id)

  if _menu.parent then print("New menu has parent: " .. _menu.parent.id) end

  return _menu

end

--[[

Mouse leaves menu
  unless it has an active submenu
    close menu

--]]

return setmetatable(menu,
  {
    __call = function(_, ...) return menu:new(...) end
  }
)
