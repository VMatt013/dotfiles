local awful = require("awful")
local modes = require("interface.bar.modes")

awful.screen.connect_for_each_screen(function(s)
	awful.tag({ "1", "2", "3", "4", "5" }, s, awful.layout.layouts[1])

	s.tasklist = require("interface.widgets.tasklist")(s, 300)
	s.taglist = require("interface.widgets.taglist")(s)

	local bar = modes.laptop(s)
	s.bar = bar
	--local dock = modes["tablet-right"](s)
	awesome.connect_signal("bar::change_mode", function(mode)
		s.bar:remove()
		s.bar = modes[mode](s)
	end)
end)
