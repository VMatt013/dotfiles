local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")

local util = require("utils.volume")

local ICON_DIR = require("icons")

local mutecolor = beautiful.bg_urgent

local maincolor = beautiful.fg_color

local widget = wibox.widget({

	{
		id = "icon",
		image = ICON_DIR .. "volume-med.svg",
		resize = true,
		widget = wibox.widget.imagebox,
	},
	max_value = 100,
	thickness = 2,
	start_angle = 4.71238898, -- 2pi*3/4
	forced_height = 18,
	forced_width = 18,
	bg = "#ffffff11",
	paddings = 1,
	value = 50,
	widget = wibox.container.arcchart,
	update = function(self)
		self.value = util:get_volume()
	end,
	mute = function(self)
		local icon = self:get_children_by_id("icon")[1]
		icon:set_image(ICON_DIR .. "volume-off.svg")
		self.colors = { mutecolor }
	end,
	unmute = function(self)
		local icon = self:get_children_by_id("icon")[1]
		icon:set_image(ICON_DIR .. "volume-med.svg")
		self.colors = { maincolor }
	end,
})

widget:buttons(awful.util.table.join(
	awful.button({}, 3, function()
		if popup.visible then
			popup.visible = not popup.visible
		else
			rebuild_popup()
			popup:move_next_to(mouse.current_widget_geometry)
		end
	end),
	awful.button({}, 4, function()
		util:up_without_popup()
		widget:update()
	end),
	awful.button({}, 5, function()
		util:down_without_popup()
		widget:update()
	end),
	awful.button({}, 2, function()
		volume:mixer()
	end),
	awful.button({}, 1, function()
		volume:toggle()
	end)
))
return widget
