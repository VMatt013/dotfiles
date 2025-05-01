local awful = require("awful")
local gears = require("gears")
local Debug = require("Debug")

local TOUCHSCREEN = "Wacom HID 5308 Finger"
local PEN = "Wacom HID 5308 Pen Pen (0x82207b0a)"
local SCREEN = "eDP-1"

local in_tablet_mode = false
local last_orientation = nil

-- Parse output like (<'normal'>,) -> "normal"
local function parse_orientation(output)
	return output:match("<'(.-)'>")
end

-- Rotate screen and map inputs
local function rotate_screen_and_input(orientation)
	if not in_tablet_mode then
		return
	end

	local rotate_map = {
		["normal"] = "normal",
		["left-up"] = "left",
		["right-up"] = "right",
		["bottom-up"] = "inverted",
	}

	local rotation = rotate_map[orientation]
	if not rotation then
		return
	end

	awful.spawn.with_shell("xrandr --output " .. SCREEN .. " --rotate " .. rotation)
	awful.spawn.with_shell("xinput map-to-output '" .. TOUCHSCREEN .. "' '" .. SCREEN .. "'")
	awful.spawn.with_shell("xinput map-to-output '" .. PEN .. "' '" .. SCREEN .. "'")
end

-- Timer to poll orientation every second
gears.timer({
	timeout = 1,
	autostart = true,
	call_now = true,
	callback = function()
		awesome.spawn(
			"gdbus call --system --dest net.hadess.SensorProxy --object-path /net/hadess/SensorProxy --method net.hadess.SensorProxy.ClaimAccelerometer"
		)
		awful.spawn.easy_async_with_shell(
			"gdbus call --system --dest net.hadess.SensorProxy --object-path /net/hadess/SensorProxy --method org.freedesktop.DBus.Properties.Get net.hadess.SensorProxy AccelerometerOrientation",
			function(stdout)
				local orientation = parse_orientation(stdout)
				if orientation and orientation ~= last_orientation then
					last_orientation = orientation
					rotate_screen_and_input(orientation)

					local mode
					if orientation == "normal" or orientation == "bottom" then
						mode = "tablet-horizontal"
					elseif orientation == "left-up" or orientation == "right-up" then
						mode = "tablet-vertical"
					end

					if mode then
						awesome.emit_signal("bar::change_mode", mode)
					end
				end
			end
		)
	end,
})

-- Respond to tablet mode toggle
awesome.connect_signal("tablet_mode::changed", function(state)
	in_tablet_mode = state

	if not state then
		awesome.emit_signal("bar::change_mode", "laptop")
		awful.spawn.with_shell("xrandr --output " .. SCREEN .. " --rotate normal")
		awful.spawn.with_shell("xinput map-to-output '" .. TOUCHSCREEN .. "' '" .. SCREEN .. "'")
		awful.spawn.with_shell("xinput map-to-output '" .. PEN .. "' '" .. SCREEN .. "'")
	else
		awesome.emit_signal("bar::change_mode", "tablet-horizontal")
	end
end)
