local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")

local theme = require("theme.bar-test")
local rounded = theme.rects.rounded

local dpi = beautiful.xresources.apply_dpi

local create = function(s)
	local tasklist_buttons = gears.table.join({
		awful.button({}, 1, function(c)
			if not c.active then
				c:activate({
					context = "through_dock",
					switch_to_tag = true,
				})
			else
				c.minimized = true
			end
		end),
		awful.button({}, 4, function()
			awful.client.focus.byidx(-1)
		end),
		awful.button({}, 5, function()
			awful.client.focus.byidx(1)
		end),
	})

	tasklist = awful.widget.tasklist({
		screen = s,
		filter = awful.widget.tasklist.filter.currenttags,
		-- sort clients by tags
		source = function()
			local ret = {}

			for _, t in ipairs(s.tags) do
				gears.table.merge(ret, t:clients())
			end

			return ret
		end,
		buttons = tasklist_buttons,
		style = {
			shape = gears.shape.rounded_rect,
		},
		layout = {
			spacing = dpi(5),
			layout = wibox.layout.fixed.horizontal,
		},
		widget_template = {
			{
				{
					id = "icon_role",
					widget = wibox.widget.imagebox,
				},
				margins = dpi(3),
				widget = wibox.container.margin,
			},
			id = "background_role",
			bg = "#eb4034",
			widget = wibox.container.background,
		},
		ontop = true,
		placement = awful.placement.centered,
	})

	local rounded_tasklist = wibox.widget({
		{
			tasklist,
			top = 0,
			bottom = 0,
			left = 5,
			right = 5,

			widget = wibox.container.margin,
		},
		bg = beautiful.bg_normal,
		shape = gears.shape.rounded_rect,
		widget = wibox.container.background,
	})

	return rounded_tasklist
end

return create
