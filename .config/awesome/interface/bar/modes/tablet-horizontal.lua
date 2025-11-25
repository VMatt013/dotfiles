local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local wibox = require("wibox")

local widgets = require("interface.widgets")

function create_bar(s)
	bar = awful.wibar({
		border_width = beautiful.bar.border_width or 3,
		border_color = beautiful.bar.border_color or beautiful.colors.secondary,
		position = beautiful.bar.position or "top",
		height = beautiful.bar.height or 30,
		margins = beautiful.bar.margins or { top = 0, bottom = 0, left = 0, right = 0 },
		fg = beautiful.bar.fg or beautiful.fg_normal,
		bg = beautiful.bar.bg or beautiful.colors.main,
		shape = beautiful.bar.shape or gears.shape.rounded_rect,
		visible = true,
		screen = s,
	})

	bar:setup({
		layout = wibox.layout.align.horizontal,
		expand = "none",
		{ -- Left widgets
			layout = wibox.layout.fixed.horizontal,
			widgets.margin(widgets.logout_menu, true, _, _, _, 10),
			widgets.margin(s.taglist),
			widgets.margin(widgets.spotify_widget({ max_length = 40 }), true),
			widgets.margin(widgets.bluelight, true),
			widgets.margin(widgets.caffeine, true),
		},
		-- Middle widget
		widgets.margin(s.tasklist, true),
		{ -- Right widgets
			layout = wibox.layout.fixed.horizontal,
			widgets.margin(widgets.my_systray, true),
			--margin(headphone_battery()),
			widgets.margin(widgets.kde_battery({ device_id = "502889c4_a2e6_4813_afc4_99dc2069a45b" })),
			widgets.margin(widgets.battery_arc()),
			widgets.margin(widgets.volume_widget()),
			widgets.margin(widgets.clock),
		},
	})
	return bar
end

return create_bar
