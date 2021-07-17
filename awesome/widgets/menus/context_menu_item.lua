--local widget = require "lib.awful.hotkeys_popup.widget"

local beautiful = require("beautiful")
local wibox = require("wibox")
local protected_call = require("gears.protected_call")
local inspect = require("lua_modules.inspect")
local markup = require("utils.pango_markup")
local awful = require("awful")

local screen = _G.screen
local mouse = _G.mouse


local menu_item = {
  icon_size = 0,
  bg = beautiful.bar.bg_normal,
  bg_normal = beautiful.bar.bg_normal,
  bg_focus = beautiful.bg_focus,
  fg_normal = beautiful.fg_normal,
  fg_focus = beautiful.fg_focus,
  separation = 2,
  padding_left = 3,
  padding_right = 3,
  submenu = nil,
  is_selected = false, -- Whether the cursor is currently over the item,
  parent_menu = nil
}

menu_item.__index = menu_item


-- Returns a widget representing a menu text entry
function menu_item:text_item(args)

  -- print("args:   " .. inspect(args))

  local text_item = {
    text = args.text or args[1] or "",
    cmd = args.cmd or args[2] or nil,
    icon = args.icon or args[3] or nil
  }

  text_item.markup = markup({
    text = text_item.text,
    foreground = self.fg_normal
  })

  if (text_item.cmd) then

    text_item.is_selectable = true 

    if (type(text_item.cmd) == "table") then

      text_item.has_submenu = true

    end

  end

  text_item.text_widget = wibox.widget {
    widget = wibox.widget.textbox,
    text = text_item.text,
    markup = text_item.markup:generate()
  }

  text_item.widget = wibox.widget {
    widget = wibox.container.margin,
    margins = self.padding,
    {
      layout = wibox.layout.align.horizontal,
      {
        widget = wibox.widget.imagebox,
        image = text_item.icon
      },
      text_item.text_widget
    }
  }

  if type(text_item.cmd) == "function" then
    
    text_item.widget:connect_signal("button::press",
      function(_, _, _, button)
        if (button == 1) then
          text_item.cmd()
        end
      end
    )
    
  else
    
    text_item.widget:connect_signal("button::press",
      function(_, _, _, button)
        if (button == 1) then
          awful.spawn.easy_async_with_shell(text_item.cmd)
        end
      end
    )
    
  end
  
  

  return text_item

end


-- A header menu item. Is not selectable
function menu_item:header_item(args)

  local header_item = {
    text = args.text or args[1] or "",
    is_selectable = false
  }

  header_item.markup = markup({
    text = header_item.text,
    weight = "bold",
    foreground = self.fg_normal
  })

  header_item.widget = wibox.widget {
    widget = wibox.widget.textbox,
    markup = header_item.markup:generate()
  }

  header_item.text_widget = header_item.widget

  return header_item
end


-- A seperator menu item. Is not selectable
function menu_item:separator_item(args)

  local separator_item = {
    is_selectable = false
  }

  separator_item.widget = wibox.widget {
    widget = wibox.widget.separator,
    forced_height = 1,
  }

  return separator_item

end


function menu_item:set_text_color(color)

  if self.text_widget and self.markup then    
    self.markup.foreground = color
    self.text_widget.markup = self.markup:generate()
  end

end


menu_item.item_type = {
  text = menu_item.text_item,
  header = menu_item.header_item,
  separator = menu_item.separator_item
}


function menu_item:new(parent_menu, args)

  args = args or {}
  args.type = args.type or "text"
  
  local _menu_item = {}

  if args.is_widget then

    _menu_item = args

  else
    
    local item = protected_call(args.type, args)
    if (item) then
      _menu_item = item
    else
      local type_func = self.item_type[args.type]

      if type_func then
        _menu_item = type_func(self, args)
      else
          print("Unrecognized menu item type")
          --return
      end
    end
  end
  
  _menu_item.parent_menu = parent_menu

  setmetatable(_menu_item, menu_item)

  -- local _menu_item = {
  --   parent_menu = parent_menu,
  --   type = args.type or "text",
  --   -- text = args.text or args[1] or "",
  --   -- cmd = args.cmd or args[2] or nil
  -- }

  local _menu_item_widget = _menu_item.widget

  _menu_item.widget = wibox.widget {
    widget = wibox.container.background,
    {
      widget = wibox.container.margin,
      left = self.padding_left,
      right = self.padding_right,
      top = self.separation / 2,
      bottom = self.separation / 2,
      _menu_item_widget
    }
  }

  -- print("is selectable: " .. tostring(_menu_item.is_selectable)) 
  

  if _menu_item.is_selectable then

    _menu_item.widget:connect_signal("mouse::enter", 
      function(widget)

        _menu_item.geometry = mouse.current_widget_geometry

        print("Mouse entered entry")

        _menu_item.widget.bg = _menu_item.bg_focus
        _menu_item:set_text_color(_menu_item.fg_focus)

        _menu_item.is_selected = true

        if _menu_item.submenu then

          print("Entry has submenu")

          _menu_item.submenu:show()
          _menu_item.parent_menu.active_submenu = _menu_item.submenu

        end

      end
    )

    _menu_item.widget:connect_signal("mouse::leave",
      function(widget)

        print("Mouse left entry")
        
        _menu_item.is_selected = false

        local submenu = _menu_item.submenu

        -- if this menu item has a submenu
        if submenu then

          print("Entry submenu is: " .. submenu.id)

          -- If submenu is not under the cursor
          if not submenu:is_under_mouse() then
            _menu_item.widget.bg = _menu_item.bg_normal
            _menu_item:set_text_color(_menu_item.fg_normal)
            submenu:hide()
          end

          -- if submenu:is_active() then print("Submenu is active") end

          -- if not submenu:is_active() then
          --   print("Submenu is not active")
          --   widget.bg = self.item_bg_normal
          --   if not submenu:is_under_mouse() then
          --     submenu:hide()
          --   end
            
          -- end
        else
          _menu_item.widget.bg = _menu_item.bg_normal
          _menu_item:set_text_color(_menu_item.fg_normal)
        end

      end
    )

  end

  return _menu_item

end


return setmetatable(menu_item,
  {
    __call = function(_, ...) return menu_item:new(...) end
  }
)
