local awful = require("awful")
local beautiful = require("beautiful")
local naughty = require("naughty")
local wibox = require("wibox")
local watch = require("awful.widget.watch")

local UPDATE_INTERVAL = 10 -- Update every 10 seconds

local ICON_DIR = require("icons")

local batteryarc_widget = {}

local function worker(user_args)
	local user_args = user_args or {}
	local args = user_args or {}

	local MAX_CHARGE = user_args.max_charge or 100
	local font = args.font or beautiful.font
	local arc_thickness = args.arc_thickness or 2
	local size = args.size or 20
	local notification_position = args.notification_position or "top_right" -- see naughty.notify position argument

	local main_color = args.main_color or beautiful.fg_color
	local low_level_color = args.low_level_color or "#e53935"
	local medium_level_color = args.medium_level_color or "#c0ca33"

	local warning_msg_title = args.warning_msg_title or "Houston, we have a problem"
	local warning_msg_text = args.warning_msg_text or "KDE Battery is dying"
	local warning_msg_position = args.warning_msg_position or "bottom_right"
	local warning_msg_icon = args.warning_msg_icon or ""
	local enable_battery_warning = args.enable_battery_warning
	if enable_battery_warning == nil then
		enable_battery_warning = true
	end

	local charge = 0
	local is_kdeconnect_open = false -- Track whether the app is open

	-- Create the text widget for showing the charge percentage
	local text = wibox.widget({
		font = font,
		align = "center",
		valign = "center",
		widget = wibox.widget.textbox,
	})

	local text_with_background = wibox.container.background(text)

	-- Create the arc widget
	batteryarc_widget = wibox.widget({
		text_with_background,
		max_value = MAX_CHARGE,
		rounded_edge = true,
		thickness = arc_thickness,
		start_angle = 4.71238898, -- 2pi*3/4
		forced_height = size,
		forced_width = size,
		bg = beautiful.bg_color,
		paddings = 2,
		widget = wibox.container.arcchart,
		value = 100,
	})

	-- Create the icon widget (imagebox)
	local icon = wibox.widget.imagebox(ICON_DIR .. "mobile.svg") -- Default icon when working
	icon.resize = true
	icon.forced_height = size * 0.8
	icon.forced_width = size * 0.8

	-- Use a place container to center the icon inside the arc
	local icon_container = wibox.container.place(icon)

	-- Combine the arc and the icon inside a container
	local widget_with_icon = wibox.widget({
		{
			batteryarc_widget,
			icon_container,
			layout = wibox.layout.stack,
		},
		widget = wibox.container.margin,
		margins = 0,
	})

	local last_battery_check = os.time()

	--[[ Show warning notification ]]
	local function show_battery_warning()
		naughty.notify({
			icon = warning_msg_icon,
			icon_size = 100,
			text = warning_msg_text,
			title = warning_msg_title,
			timeout = 25,
			hover_timeout = 0.5,
			position = warning_msg_position,
			bg = "#F06060",
			fg = "#EEE9EF",
			width = 300,
		})
	end

	local function update_widget(widget, data)
		if data == "no_device" then
			icon:set_image(ICON_DIR .. "mobile-slash.svg") -- Error icon
			batteryarc_widget.visible = false -- Hide the arc
			status = "Disconnected"
			return
		end

		batteryarc_widget.visible = true -- Ensure visibility for valid data

		if data:match("^battery_available:") then
			local charge = tonumber(data:match("battery_available:(%d+)"))
			batteryarc_widget.value = charge

			icon:set_image(ICON_DIR .. "mobile.svg") -- Working icon
			status = charge .. "%"

			-- Color based on charge level
			if charge < 20 then
				batteryarc_widget.colors = { low_level_color }
				if enable_battery_warning and os.difftime(os.time(), last_battery_check) > 300 then
					last_battery_check = os.time()
					show_battery_warning()
				end
			elseif charge < 40 then
				batteryarc_widget.colors = { medium_level_color }
			else
				batteryarc_widget.colors = { main_color }
			end
		elseif data == "battery_unavailable" then
			icon:set_image(ICON_DIR .. "mobile-slash.svg") -- Error icon
			batteryarc_widget.colors = { low_level_color }
			batteryarc_widget.value = 0
			status = "Battery Unavailable"
		end
	end

	-- Watch KDE Connect for battery level

	watch(
		"headsetcontrol -b",
		UPDATE_INTERVAL, -- Update every 10 seconds
		function(widget, stdout)
			-- Parse the output of headsetcontrol -b
			local device_found = stdout:match("Found SteelSeries Arctis Nova")
			local battery_status = stdout:match("Status: (%S+)")
			local battery_level = stdout:match("Level: (%d+)%%")

			if not device_found then
				-- No device found
				update_widget(widget, "no_device")
			elseif battery_status == "BATTERY_AVAILABLE" and battery_level then
				-- Battery is available
				update_widget(widget, "battery_available:" .. battery_level)
			elseif battery_status == "BATTERY_UNAVAILABLE" then
				-- Battery is unavailable
				update_widget(widget, "battery_unavailable")
			end
		end,
		batteryarc_widget -- Pass the widget to be updated
	)

	-- Hover text on mouse enter
	widget_with_icon:connect_signal("mouse::enter", function()
		local hover_text
		if status == "Disconnected" then
			hover_text = "Device not connected. Please check connection."
		elseif status == "Battery Unavailable" then
			hover_text = "Battery status unavailable. Ensure the device is powered on."
		else
			hover_text = "Battery Level: " .. charge .. "%"
		end

		-- Show the hover text
		notification = naughty.notify({
			text = hover_text,
			title = "Battery Status",
			timeout = 5,
			width = 200,
			position = notification_position,
		})
	end)

	-- Hide notification on mouse leave
	widget_with_icon:connect_signal("mouse::leave", function()
		naughty.destroy(notification)
	end)

	-- Hide notification on mouse leave
	widget_with_icon:connect_signal("mouse::leave", function()
		naughty.destroy(notification)
	end)

	return widget_with_icon
end

return setmetatable(batteryarc_widget, {
	__call = function(_, ...)
		return worker(...)
	end,
})
