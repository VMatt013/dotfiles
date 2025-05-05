-------------------------------------------------
-- Blue Light Filter Widget for Awesome Window Manager
-- More details could be found here:
-- https://github.com/streetturtle/awesome-wm-widgets/tree/master/github-prs-widget

-- @author VMatt
-- @copyright 2024 VMatt
-------------------------------------------------

local awful = require("awful")
local wibox = require("wibox")

local ICON_DIR = require("interface.icons")
local CMD = "redshift"
local NIGHT_CMD = "-O 2500 -g 0.75"
local DAY_CMD = "-x"
local day = true

local widget = wibox.widget({
	{

		{
			id = "icon",
			image = ICON_DIR .. "sun.svg",
			resize = true,
			widget = wibox.widget.imagebox,
		},
		layout = wibox.layout.fixed.horizontal,
		widget = wibox.container.margin,
	},
	border_width = 5,
	widget = wibox.container.background,
	layout = wibox.layout.fixed.horizontal,
})

function widget:update()
	local icon = self:get_children_by_id("icon")[1]
	if day then
		icon:set_image(ICON_DIR .. "sun.svg")
	else
		icon:set_image(ICON_DIR .. "moon.svg")
	end
end

local function on_day()
	awful.spawn(CMD .. " " .. DAY_CMD)
	widget:update()
end

local function on_night()
	awful.spawn(CMD .. " " .. NIGHT_CMD)
	widget:update()
end

local function toggle()
	day = not day
	if day then
		on_day()
	else
		on_night()
	end
end

widget:buttons(awful.util.table.join(awful.button({}, 1, function()
	toggle()
end)))

return widget
