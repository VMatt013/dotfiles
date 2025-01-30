local Debug = require("Debug")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local gears = require("gears")

---------------------
-- Widgets------------
--------------------
local promptbox = require("widgets.promptbox")
local clock = wibox.widget.textclock()
local battery_arc = require("widgets.battery-status.arc")
local kde_battery = require("widgets.kde-battery.arc")
local headphone_battery = require("widgets.headphone-battery")
local logout_menu = require("widgets.logout-menu")
local volume_widget = require("widgets.pactl.volume")
local spotify_widget = require("widgets.spotify")
local my_systray = wibox.widget.systray()
local keyboard = require("widgets.keyboard")
local margin = require("widgets.margin")
local bluelight = require("widgets.bluelight")

awful.screen.connect_for_each_screen(function(s)
	awful.tag({ "1", "2", "3", "4", "5" }, s, awful.layout.layouts[1])

	s.tasklist = require("widgets.tasklist")(s, 300)
	s.taglist = require("widgets.taglist")(s)
	s.promptbox = promptbox

	s.bar = awful.wibar({
		border_width = beautiful.bar.border_width or 3,
		border_color = beautiful.bar.border_color or beautiful.colors.secondary,
		position = beautiful.bar.position or "top",
		height = beautiful.bar.height or 30,
		margins = beautiful.bar.margins or { top = 0, bottom = 0, left = 0, right = 0 },
		fg = beautiful.bar.fg or beautiful.fg_normal,
		bg = beautiful.bar.bg or beautiful.colors.main,
		shape = beautiful.bar.shape or gears.shape.rounded_rect,
		screen = s,
		visible = true,
	})

	if s == screen.primary then
		s.bar:setup({
			layout = wibox.layout.align.horizontal,
			expand = "none",
			{ -- Left widgets
				layout = wibox.layout.fixed.horizontal,
				margin(logout_menu, true, _, _, _, 10),
				margin(s.taglist),
				margin(spotify_widget({ max_length = 40 }), true),
				margin(promptbox, true),
				margin(bluelight, true),
			},
			-- Middle widget
			margin(s.tasklist, true),
			{ -- Right widgets
				layout = wibox.layout.fixed.horizontal,
				margin(keyboard, true),
				margin(my_systray, true),
				--margin(headphone_battery()),
				margin(kde_battery({ device_id = "502889c4_a2e6_4813_afc4_99dc2069a45b", max_charge = 81 })),
				margin(battery_arc()),
				margin(volume_widget()),
				margin(clock),
			},
		})
	else
		s.bar:setup({
			layout = wibox.layout.align.horizontal,
			expand = "none",
			{ -- Left widgets
				layout = wibox.layout.fixed.horizontal,
				margin(s.taglist),
				margin(spotify_widget({ max_length = 40 }), true),
			},
			-- Middle widget
			margin(s.tasklist, true),
			{ -- Right widgets
				layout = wibox.layout.fixed.horizontal,
				margin(battery_arc()),
				margin(clock),
			},
		})
	end
end)
