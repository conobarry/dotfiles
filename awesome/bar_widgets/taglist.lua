-- Awesome libraries
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local gears = require("gears")

-- Local libraries
local bindings = require("configuration.bindings")
local wibarutils = require("utils.wibar")
local inspect = require("lua_modules.inspect")

local function taglist(screen)

  local colors = {
    10, 6, 5, 4, 1
  }

  local tag_container = wibox.widget {
    layout = wibox.layout.fixed.horizontal,
    spacing = 0
  }

  for key, tag in pairs(screen.tags) do

    local tasklist_widget = wibox.widget {
      layout = wibox.layout.fixed.horizontal,
      spacing = 0
    }

    local tag_widget = wibox.widget {
      widget = wibox.container.background,
      tag = tag,
      shape = wibarutils.right_parallelogram,
      color_index = colors[key],
      bg_normal = beautiful.bar.bg_normal,--beautiful.rainbow_colors_light[colors[key]],
      bg_focus = beautiful.bar.bg_focus,--beautiful.rainbow_colors[colors[key]],
      {
        widget = wibox.container.margin,
        left = 10,
        right = 10,
        {
          layout = wibox.layout.fixed.horizontal,
          spacing = 4,
          {
            widget = wibox.widget.textbox,
            markup = string.format("<span font='%s' foreground='%s'>%s</span>", beautiful.bar.font, beautiful.bar.fg_black, tag.name)
          },
          {
            widget = tasklist_widget
          }
        }
      }
    }

    tag_widget.tasklist = tasklist_widget

    tag_widget.bg = key == 1 and tag_widget.bg_focus or tag_widget.bg_normal


    function tag_widget:update()
      --print("update")
      --print(inspect(self.tag:clients()))

      tag.widget.tasklist:reset()

      for _, client in pairs(self.tag:clients()) do

        local task_widget = wibox.widget {
          widget = wibox.container.background,
          shape = wibarutils.right_parallelogram,
          client = client,
          {
            widget = wibox.container.margin,
            left = beautiful.dpi(2),
            right = beautiful.dpi(2),
            {
              widget = wibox.container.margin,
              margins = beautiful.dpi(5),
              {
                widget = wibox.widget.imagebox,
                image = client.icon
              }
            }
          }
        }

        task_widget:connect_signal("mouse::enter",
          function(widget)
            widget.bg = "#ede7e3"
          end
        )

        task_widget:connect_signal("mouse::leave",
          function(widget)
            widget.bg = "#000000"..00
          end
        )

        task_widget:connect_signal("button::press",
          function(widget, _, _, button)
            print(inspect(widget.client.name, {depth = 1}))
            local client = widget.client
            if (button == 1) then
              if client == _G.client.focus then
                client.minimized = true
              else
                client:emit_signal("request::activate", "tasklist", {raise = true})
              end
            elseif (button == 3) then
              awful.menu.client_list({theme = {width = 250}})
            elseif (button == 4) then
              awful.client.focus.byidx(1)
            elseif (button == 5) then
              awful.client.focus.byidx(-1)
            end
          end
        )

        tag.widget.tasklist:add(task_widget)

      end
    end

    tag_widget:connect_signal("button::press",
      function(_, _, _, button)
        if (button == 1) then
          tag:view_only()
        elseif (button == 4) then
          awful.tag.viewnext(tag.screen)
        elseif (button == 5) then
          awful.tag.viewprev(tag.screen)
        end
      end
    )

    tag_widget:connect_signal("mouse::enter",
      function(widget)
        if not widget.tag.selected then widget.bg = widget.bg_focus end
      end
    )

    tag_widget:connect_signal("mouse::leave",
      function(widget)
        if not widget.tag.selected then widget.bg = widget.bg_normal end
      end
    )

    tag:connect_signal("property::selected",
      function(t)
        tag.widget.bg = tag.widget.bg_focus
        for _, other_tag in pairs(tag.screen.tags) do
          if (tag ~= other_tag) then
            local widget = other_tag.widget
            --widget.bg_normal = tag.widget.bg_normal
            widget.bg = tag_widget.bg_normal
          end
        end
      end
    )

    tag:connect_signal("tagged",
      function(tag, client)
        --print("tagged")
        tag.widget:update()
      end
    )

    tag:connect_signal("untagged",
      function (tag, client)
        --print("untagged")
        tag.widget:update()
      end
    )

    tag.widget = tag_widget
    tag_container:add(tag_widget)

  end

  return tag_container

end

return taglist