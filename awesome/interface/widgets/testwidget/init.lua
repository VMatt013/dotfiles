local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")

local ICON_DIR = require("icons")

local widget = wibox.widget({
	{

		{
			image = ICON_DIR .. "power.svg",
			resize = true,
			widget = wibox.widget.imagebox,
		},

		layout = wibox.container.margin,
		margins = 5,
		widget = wibox.container.margin,
	},
	border_width = 5,

	shape = function(cr, width, height)
		gears.shape.circle(cr, width, height, 10)
	end,
	widget = wibox.container.background,
	layout = wibox.layout.fixed.horizontal,
})

return widget
