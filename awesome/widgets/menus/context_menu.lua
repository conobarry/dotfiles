--local widget = require "lib.awful.hotkeys_popup.widget"


local beautiful = require("beautiful")
local wibox = require("wibox")
local protected_call = require("gears.protected_call")
local inspect = require("lua_modules.inspect")

local screen = _G.screen
local mouse = _G.mouse

local menu = {
  icon_size = 0,
  bg = beautiful.bar.bg_normal,
  item_bg_normal = beautiful.bar.bg_normal,
  item_bg_focus = beautiful.bg_focus,
  item_fg_normal = beautiful.fg_normal,
  item_fg_focus = beautiful.fg_focus,
  item_padding_left = 3,
  item_padding_right = 3,
  item_separation = 2,
  submenus = {},
  parent = nil,
  active_submenu = nil,
  is_active = false,
  entries = {},
  id = nil
}

function menu.activate()
  menu.is_active = true
  if menu.parent then
    menu.parent.active_submenu = menu
  end
end

function menu.deactivate()
  menu.is_active = false
  if menu.parent then
    menu.parent.active_submenu = nil
  end
end

function menu.create_item_widget(menu_item)  

  local item_widget = wibox.widget {
    widget = wibox.container.background,
    {
      widget = wibox.container.margin,
      left = menu.item_padding_left,
      right = menu.item_padding_right,
      top = menu.item_separation / 2,
      bottom = menu.item_separation / 2,
      menu_item.widget
    }
  }

  if menu_item.is_selectable then

    item_widget:connect_signal("mouse::enter", 
      function(widget)
        print("Mouse entered entry")

        widget.bg = menu.item_bg_focus
        menu_item.is_selected = true

        if menu_item.submenu then
          print("Entry has submenu")
          menu_item.submenu:show()
          menu.active_submenu = menu_item.submenu
        end

      end
    )

    item_widget:connect_signal("mouse::leave",
      function(widget)
        widget.bg = menu.item_bg_normal

        if menu_item.submenu then
          if not menu_item.submenu.is_active then
            menu_item.submenu:hide()
          end
        else
          menu_item.is_selected = false
        end

      end
    )

  end

  return item_widget
end


-- Returns a widget representing a menu text entry
function menu.text_item(args)

  local menu_item = {
    text = args.text or args[1] or "",
    cmd = args.cmd or args[2] or nil,
    icon = args.icon or args[3] or nil
  }

  if (menu_item.cmd) then

    menu_item.is_selectable = true 

    if (type(menu_item.cmd) == "table") then
      
      menu_item.submenu = menu.new({
        items = menu_item.cmd,
        parent = menu
      })

      table.insert(menu.submenus, menu_item.submenu)

    end

  end

  menu_item.widget = wibox.widget {
    widget = wibox.container.margin,
    margins = menu.item_padding,
    {
      layout = wibox.layout.align.horizontal,
      {
        widget = wibox.widget.imagebox,
        image = menu_item.icon
      },
      {
        widget = wibox.widget.textbox,
        text = menu_item.text
      }
    }
  }

  return menu_item

end


-- A header menu item. Is not selectable
function menu.header_item(args)

  local menu_item = {
    text = args.text or args[1] or "",
    is_selectable = false
  }

  menu_item.widget = wibox.widget {
    widget = wibox.widget.textbox,
    markup = string.format("<b>%s</b>", menu_item.text)
    --text = args.text
  }

  return menu_item
end


-- A seperator menu item. Is not selectable
function menu.separator_item(args)

  local menu_item = {
    is_selectable = false
  }

  menu_item.widget = wibox.widget {
    widget = wibox.widget.separator,
    forced_height = 1,
  }

  return menu_item

end


menu.item_type = {
  text = menu.text_item,
  header = menu.header_item,
  separator = menu.separator_item
}

function menu.entry(args)

  if args.type then
    local type_func = menu.entry_type[args.type]
    if type_func then
        return type_func(args)
    else
        print("Unrecognized menu item type: '"..args.type.."'")
        return
    end
  else
      return menu.entry_type.text(args)
  end

end


--[[
  Public Functions
--]]

function menu:add(args)
  
  print(inspect(args, {depth = 1}))

  local entry = {}

  if args.is_widget then

    entry = menu.create_item_widget(args)

  else

    args.type = args.type or "text"
    
    local item = protected_call(args.type, args)
    if (item) then
      entry = item
    else
      local type_func = menu.item_type[args.type]

      if type_func then
          entry = type_func(args)
      else
          print("Unrecognized menu item type: '"..args.type.."'")
          return
      end
    end

    entry = menu.create_item_widget(entry)

  end

  self.wibox.widget:add(entry)
  table.insert(menu.entries, entry)

end


function menu:show()

  print("Menu being shown")

  self.is_active = true
  if self.parent then
    print("Menu has a parent")
    self.parent.active_submenu = self
  end

  self.wibox.x = mouse.coords().x - 2
  self.wibox.y = mouse.coords().y - 2
  self.wibox.visible = true

end


function menu:hide()

  if self.active_submenu then
    self.active_submenu:hide()
    self.active_submenu = nil
  end

  self.wibox.visible = false
  
end


function menu:toggle()
  if self.wibox.visible then
    self:hide()
  else
    self:show()
  end
end

-- Inspect function
function print_menu(menu)
  
  result = {}

  if menu.entries then
    for k, v in pairs(menu.entries) do
      table.insert(result, v.text)
    end
  end

  -- local get_entries = function(item, path)
  --  --if path[#path] == inspect.KEY then return "hello" end
  --   return item
  -- end

  return inspect(result, {depth = 3})
  
end

local test_table = {
  name = "conor",
  age = 24,
  entries = {
    {
      text = "first",
      number = 1,
    },
    {
      text = "second",
      number = 2,
    }
  }
}
print("testing: " .. print_menu(test_table))


function menu.new(args)

  args = args or {}

  local items = args.items or {}

  local _menu = {
    add = menu.add,
    toggle = menu.toggle,
    show = menu.show,
    hide = menu.hide,
    parent = args.parent or nil,
    entries = menu.entries,
    active_submenu = nil,
    id = math.random(0, 100)
  }

  local current_screen = screen.primary

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
      print("Mouse entered menu")
      _menu.is_active = true
      if _menu.parent then
        _menu.parent.active_submenu = _menu
      end
    end
  )

  _menu.wibox:connect_signal("mouse::leave", 
    function()
      print("Mouse leaving menu: " .. tostring(_menu))
      print("Active submenu = " .. tostring(_menu.active_submenu))
      if not _menu.active_submenu then
        print("no active submenu")
        _menu:hide()
        if _menu.parent then
          if not _menu.is_active then
            print("not under mouse")
            _menu.parent:hide()
          end
        end
      end
    end
  )

  print("Menu created: " .. _menu.id)

  --if _menu.parent then print("New menu has parent: " .. _menu.parent.id) end

  return _menu

end

return setmetatable(menu,
  {
    __call = function(_, ...) return menu.new(...) end
  }
)
