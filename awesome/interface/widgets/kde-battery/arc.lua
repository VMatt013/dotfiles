local awful = require("awful")
local beautiful = require("beautiful")
local naughty = require("naughty")
local wibox = require("wibox")
local watch = require("awful.widget.watch")

local UPDATE_INTERVAL = 10 -- Update every 10 seconds

local ICON_DIR = require("icons")

local batteryarc_widget = {}

local function worker(user_args)
	local args = user_args or {}

	local MAX_CHARGE = user_args.max_charge or 100
	local DEVICE_ID = user_args.device_id or ""
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

	-- Watch function for battery percentage and charging status
	local function update_widget(widget, stdout)
		local match_charge = stdout:match("'charge': <(%d+)>")
		local match_charging = stdout:match("'isCharging': <(%w+)>")

		-- Error condition: device not connected or invalid data
		if not match_charge or not match_charging then
			icon:set_image(ICON_DIR .. "mobile-slash.svg") -- Error icon
			batteryarc_widget.visible = false -- Hide the arc
			status = "Disconnected"
			return
		end

		-- Restore the arc visibility if there's valid data
		batteryarc_widget.visible = true

		-- Update arc value
		charge = tonumber(match_charge)
		batteryarc_widget.value = charge

		if match_charging == "true" then
			icon:set_image(ICON_DIR .. "mobile-charge.svg") -- Charging icon
			text_with_background.fg = "#000000"
			status = "Charging"
		else
			icon:set_image(ICON_DIR .. "mobile.svg") -- Working icon
			text_with_background.fg = main_color
			status = ""
		end

		-- Color based on charge level
		if charge < 20 and charge > 0 then
			batteryarc_widget.colors = { low_level_color }
			if
				enable_battery_warning
				and match_charging ~= "true"
				and os.difftime(os.time(), last_battery_check) > 300
			then
				-- if 5 minutes have elapsed since the last warning
				last_battery_check = os.time()

				show_battery_warning()
			end
		elseif charge > 20 and charge < 40 then
			batteryarc_widget.colors = { medium_level_color }
		else
			batteryarc_widget.colors = { main_color }
		end
	end

	-- Watch KDE Connect for battery level
	watch(
		"gdbus call --session "
			.. "--dest org.kde.kdeconnect "
			.. "--object-path /modules/kdeconnect/devices/"
			.. DEVICE_ID
			.. "/battery "
			.. "--method org.freedesktop.DBus.Properties.GetAll "
			.. "org.kde.kdeconnect.device.battery",
		UPDATE_INTERVAL, -- Update every 10 seconds
		update_widget,
		batteryarc_widget -- Pass the widget to be updated
	)

	local menu_items = {
		{
			"Open Phone Screen",
			function()
				awful.spawn.easy_async_with_shell("pgrep -x scrcpy", function(stdout)
					if stdout == "" then
						awful.spawn("scrcpy", false)
					else
						naughty.notify({ text = "Phone screen is already open!" })
					end
				end)
			end,
		},
		{
			"Open Phone Sound",
			function()
				awful.spawn.easy_async_with_shell("pgrep -x scrcpy", function(stdout)
					if stdout == "" then
						awful.spawn("scrcpy --no-control --max-fps=1 -m 600 --no-window", false)
					else
						naughty.notify({ text = "Phone sound is already open!" })
					end
				end)
			end,
		},
		{
			"Close Phone App",
			function()
				awful.spawn("pkill scrcpy", false)
			end,
		},
		{
			"Open KDE Connect",
			function()
				awful.spawn("kdeconnect-app", false)
			end,
		},
		{
			"ADB Connect",
			function()
				awful.spawn("alacritty -e adb-wifi")
			end,
		},
	}

	local popup_menu = awful.menu({ items = menu_items, theme = { width = 200 } })

	-- Right-click to open the menu
	widget_with_icon:connect_signal("button::press", function(_, _, _, button)
		if button == 3 then -- Right-click
			popup_menu:toggle()
		end
	end)

	-- Toggle KDE Connect App (Mouse Click 1)
	widget_with_icon:connect_signal("button::press", function(_, _, _, button)
		if button == 1 then
			awful.spawn.easy_async_with_shell("pgrep -x kdeconnect-app", function(stdout)
				if stdout == "" then
					awful.spawn("kdeconnect-app", false)
				else
					awful.spawn("pkill kdeconnect-app", false)
				end
			end)
		end
	end)

	-- Hover text on mouse enter
	widget_with_icon:connect_signal("mouse::enter", function()
		local hover_text = charge .. "%"
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

	return widget_with_icon
end

return setmetatable(batteryarc_widget, {
	__call = function(_, ...)
		return worker(...)
	end,
})
