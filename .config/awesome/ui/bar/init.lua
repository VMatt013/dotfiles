local awful = require("awful")

local laptop_bar = require("ui.bar.laptop")
local tablet_vertical_bar = require("ui.bar.tablet-vertical")
local tablet_horizontal_bar = require("ui.bar.tablet-horizontal")

local modes = {
	["laptop"] = laptop_bar,
	["tablet-horizontal"] = tablet_horizontal_bar,
	["tablet-vertical"] = tablet_vertical_bar,
}

awful.screen.connect_for_each_screen(function(s)
	awful.tag({ "1", "2", "3", "4", "5" }, s, awful.layout.layouts[1])

	s.tasklist = require("widgets.tasklist")(s, 300)
	s.taglist = require("widgets.taglist")(s)

	local bar = laptop_bar(s)
	s.bar = bar

	awesome.connect_signal("bar::change_mode", function(mode)
		s.bar:remove()
		s.bar = modes[mode](s)
	end)
end)
