local wibox = require("wibox")

local folder = "interface.widgets."

local promptbox = require(folder .. "promptbox")
local clock = wibox.widget.textclock()
local battery_arc = require(folder .. "battery-status.arc")
local kde_battery = require(folder .. "kde-battery.arc")
local headphone_battery = require(folder .. "headphone-battery")
--local logout_menu = require(folder .. "logout-menu")
local volume_widget = require(folder .. "pactl.volume")
local spotify_widget = require(folder .. "spotify")
local keyboard = require(folder .. "keyboard")
local margin = require(folder .. "margin")
local bluelight = require(folder .. "bluelight")

local my_systray = wibox.widget.systray()

widgets = {
	promptbox = promptbox,
	clock = clock,
	battery_arc = battery_arc,
	kde_battery = kde_battery,
	headphone_battery = headphone_battery,
	--	logout_menu = logout_menu,
	volume_widget = volume_widget,
	spotify_widget = spotify_widget,
	my_systray = my_systray,
	keyboard = keyboard,
	margin = margin,
	bluelight = bluelight,
}

return widgets
