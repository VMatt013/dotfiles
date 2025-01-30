--local beautiful = require("beautiful")
local gears = require("gears")
local awful = require("awful")
--require("awful.autofocus")
local wibox = require("wibox")
--local beautiful = require("beautiful")
--local naughty = require("naughty")
--local menubar = require("menubar")
--local hotkeys_popup = require("awful.hotkeys_popup")
--require("awful.hotkeys_popup.keys")

popup = awful.popup({
	widget = {
		{
			{
				text = "foobar",
				widget = wibox.widget.textbox,
			},
			{
				{
					text = "foobar",
					widget = wibox.widget.textbox,
				},
				bg = "#ff00ff",
				clip = true,
				shape = gears.shape.rounded_bar,
				widget = wibox.widget.background,
			},
			{
				value = 0.5,
				forced_height = 30,
				forced_width = 100,
				widget = wibox.widget.progressbar,
			},
			layout = wibox.layout.fixed.vertical,
		},
		margins = 10,
		widget = wibox.container.margin,
	},
	border_color = "#00ff00",
	border_width = 5,
	placement = awful.placement.top_left,
	shape = gears.shape.rounded_rect,
	visible = true,
})
