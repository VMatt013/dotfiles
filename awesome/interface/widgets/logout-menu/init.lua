local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local popup = require("popups.logout-menu")

local ICON_DIR = require("icons")

local logout_menu_widget = wibox.widget({
	{
		{
			image = ICON_DIR .. "power.svg",
			resize = true,
			widget = wibox.widget.imagebox,
		},
		layout = wibox.container.margin,
		margins = { left = 4, right = 4, top = 4, bottom = 4 },
	},
	border_width = 5,
	shape = function(cr, width, height)
		gears.shape.circle(cr, width, height, 10)
	end,
	widget = wibox.container.background,
	layout = wibox.layout.fixed.horizontal,
})

logout_menu_widget:buttons(awful.util.table.join(awful.button({}, 1, function()
	popup:toggle()
end)))

return logout_menu_widget
