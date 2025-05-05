local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")

local ICON_DIR = require("interface.icons")
local ICONS = { "volume-off.svg", "volume-min.svg", "volume-med.svg", "volume-max.svg" }
local volume = 50

local popup = awful.popup({
	screen = awful.screen.focused(),
	ontop = true,
	visible = false,
	shape = function(cr, width, height)
		gears.shape.rounded_rect(cr, width, height, 10)
	end,
	placement = function(c)
		awful.placement.bottom(c, { margins = { bottom = 100 } })
	end,
	border_width = 1,
	border_color = beautiful.colors.main,
	widget = {
		{
			{
				{
					image = ICON_DIR .. "volume-down.svg",
					resize = true,
					widget = wibox.widget.imagebox,
					id = "icon",
					forced_width = 20,
					forced_height = 20,
				},
				{
					{
						id = "bar",
						max_value = 100,
						value = volume,
						color = beautiful.fg_normal,
						bar_shape = beautiful.shape.rounded_rect(),
						shape = beautiful.shape.rounded_rect(),
						widget = wibox.widget.progressbar,
					},
					forced_height = 20,
					forced_width = 300,
					layout = wibox.container.rotate,
				},
				spacing = 12,
				layout = wibox.layout.fixed.horizontal,
			},
			forced_width = 300,
			margins = 8,
			layout = wibox.container.margin,
		},
		bg = beautiful.bg_normal,
		widget = wibox.container.background,
	},
})

local hide = gears.timer({ timeout = 1 })

hide:connect_signal("timeout", function()
	popup.visible = false
	hide:stop()
end)

function popup:change_icon()
	local icon = self.widget:get_children_by_id("icon")[1]

	if volume == 0 then
		icon:set_image(ICON_DIR .. ICONS[1])
	elseif volume <= 33 then
		icon:set_image(ICON_DIR .. ICONS[2])
	elseif volume <= 66 then
		icon:set_image(ICON_DIR .. ICONS[3])
	else
		icon:set_image(ICON_DIR .. ICONS[4])
	end
end

function popup:open()
	if not self.visible then
		self.visible = true
	end

	if hide.started then
		hide:again()
	else
		hide:start()
	end
end

function popup:update(value)
	volume = value
	self.widget:get_children_by_id("bar")[1].value = tonumber(volume)
	self:change_icon()
	self:open()
end

return popup
