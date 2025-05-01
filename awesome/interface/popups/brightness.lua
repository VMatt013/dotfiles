local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")

local Debug = require("Debug")

local ICON_DIR = require("icons")
local CMD = "light"
local CMD_CHANGE = CMD .. " -S"
local STEP = 1
local MIN = 1
local MAX = 100

local brightness = 0

awful.spawn.easy_async_with_shell("light", function(stdout, stderr, reason, exit_code)
	brightness = tonumber(stdout)
end)

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
	border_color = beautiful.bg_focus,
	widget = {
		{
			{
				{
					image = ICON_DIR .. "sun.svg",
					resize = true,
					widget = wibox.widget.imagebox,

					forced_width = 20,
					forced_height = 20,
				},
				{
					{
						id = "bar",
						max_value = 100,
						value = brightness,
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

function popup:update()
	awful.spawn.with_shell(CMD_CHANGE .. " " .. brightness)
	self.widget:get_children_by_id("bar")[1].value = tonumber(brightness)
	popup:open()
end

function popup:up()
	if brightness + STEP <= MAX then
		brightness = brightness + STEP
	end
	popup:update()
end

function popup:down()
	if brightness - STEP >= MIN then
		brightness = brightness - STEP
	end
	popup:update()
end

return popup
