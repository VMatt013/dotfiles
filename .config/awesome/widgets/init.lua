local wibox = require("wibox")

local promptbox = require("widgets.promptbox")
local clock = wibox.widget.textclock()
local battery_arc = require("widgets.battery-status.arc")
local kde_battery = require("widgets.kde-battery.arc")
local headphone_battery = require("widgets.headphone-battery")
local logout_menu = require("widgets.logout-menu")
local volume_widget = require("widgets.pactl.volume")
local spotify_widget = require("widgets.spotify")
local keyboard = require("widgets.keyboard")
local margin = require("widgets.margin")
local bluelight = require("widgets.bluelight")

local my_systray = wibox.widget.systray()

widgets = {
	promptbox = promptbox,
	clock = clock,
	battery_arc = battery_arc,
	kde_battery = kde_battery,
	headphone_battery = headphone_battery,
	logout_menu = logout_menu,
	volume_widget = volume_widget,
	spotify_widget = spotify_widget,
	my_systray = my_systray,
	keyboard = keyboard,
	margin = margin,
	bluelight = bluelight,
}

return widgets
