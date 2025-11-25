local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")

local ICON_DIR = require("interface.icons")

local db = require("core.utils.debug")

local popup = awful.popup({
	screen = awful.screen.focused(),
	ontop = true,
	visible = false,
	shape = function(cr, width, height)
		gears.shape.rounded_rect(cr, width, height, 10)
	end,
	placement = function(c)
		awful.placement.bottom(c, { margins = { bottom = 100 } })
	end,
	border_width = 1,
	border_color = beautiful.bg_focus,
	widget = {
		{
			{
				{
					image = ICON_DIR .. "sun.svg",
					resize = true,
					widget = wibox.widget.imagebox,

					forced_width = 20,
					forced_height = 20,
				},
				{
					{
						id = "bar",
						max_value = 100,
						value = 0,
						color = beautiful.fg_normal,
						bar_shape = beautiful.shape.rounded_rect(),
						shape = beautiful.shape.rounded_rect(),
						widget = wibox.widget.progressbar,
					},
					forced_height = 20,
					forced_width = 300,
					layout = wibox.container.rotate,
				},
				spacing = 12,
				layout = wibox.layout.fixed.horizontal,
			},
			forced_width = 300,
			margins = 8,
			layout = wibox.container.margin,
		},
		bg = beautiful.bg_normal,
		widget = wibox.container.background,
	},
})

local hide = gears.timer({ timeout = 1 })

hide:connect_signal("timeout", function()
	popup.visible = false
	hide:stop()
end)

function popup:open()
	if not self.visible then
		self.visible = true
	end

	if hide.started then
		hide:again()
	else
		hide:start()
	end
end

function popup:update(value)
	self.widget:get_children_by_id("bar")[1].value = tonumber(value)
	popup:open()
end

awesome.connect_signal("popups::brightness", function(value)
	popup:update(value)
end)
