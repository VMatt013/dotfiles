local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local wibox = require("wibox")

local widgets = require("interface.widgets")

function create_bar(s)
	bar = awful.wibar({
		border_width = beautiful.bar.border_width or 3,
		border_color = beautiful.bar.border_color or beautiful.colors.secondary,
		position = "right",
		ontop = true,
		height = 600,
		width = 30,
		margins = beautiful.bar.margins or { top = 0, bottom = 0, left = 0, right = 1 },
		fg = beautiful.bar.fg or beautiful.fg_normal,
		bg = beautiful.bar.bg or beautiful.colors.main,
		shape = beautiful.bar.shape or gears.shape.rounded_rect,
		visible = true,
		screen = s,
	})

	bar:setup({
		layout = wibox.layout.align.vertical,
		expand = "none",
		{ -- Left widgets
			layout = wibox.layout.fixed.vertical,
			widgets.margin(widgets.bluelight, true),
		},
		-- Middle widget
		--widgets.margin(s.tasklist, true),
		{ -- Right widgets
			layout = wibox.layout.fixed.vertical,
			--margin(headphone_battery()),
			widgets.margin(widgets.battery_arc()),
			widgets.margin(widgets.volume_widget()),
			widgets.margin(widgets.clock),
		},
	})
	return bar
end

return create_bar
