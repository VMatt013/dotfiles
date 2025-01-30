local awful = require("awful")
local wibox = require("wibox")
local keyboard = awful.widget.keyboardlayout

local CMD = "setxkbmap "
local INDEX = 1
local LAYOUTS = {
	"us",
	"hu",
}

local widget = wibox.widget({
	{
		{
			widget = keyboard,
		},
		layout = wibox.container.margin,
	},
	widget = wibox.container.background,
	layout = wibox.layout.fixed.horizontal,
})

function widget:set_layout(layout)
	awful.spawn(CMD .. layout)
end

function widget:cycle_layout()
	if INDEX == #LAYOUTS then
		INDEX = 1
	else
		INDEX = INDEX + 1
	end
	self:set_layout(LAYOUTS[INDEX])
end

widget:buttons(awful.util.table.join(awful.button({}, 1, function()
	widget:cycle_layout()
end)))

return widget
