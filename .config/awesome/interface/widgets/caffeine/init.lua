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
local ICON_ON = "hourglass-empty.svg"
local ICON_OFF = "hourglass-start.svg"

local CMD = "caffeine"
local isOn = false

local widget = wibox.widget({
	{

		{
			id = "icon",
			image = ICON_DIR .. ICON_OFF,
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
	if isOn then
		icon:set_image(ICON_DIR .. ICON_ON)
	else
		icon:set_image(ICON_DIR .. ICON_OFF)
	end
end

function widget:init()
	get_var()
	self:update()
end

local function turn_on()
	awful.spawn(CMD)
	widget:update()
end

local function turn_off()
	awful.spawn("pkill " .. CMD)
	widget:update()
end

local function toggle()
	isOn = not isOn
	if isOn then
		turn_on()
	else
		turn_off()
	end
end

widget:buttons(awful.util.table.join(awful.button({}, 1, function()
	toggle()
end)))

local function get_var()
	local f = io.open("")
	isOn = f:read()
	f:close()
end

local function set_var() end

return widget
