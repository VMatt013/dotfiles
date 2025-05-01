local awful = require("awful")
local gears = require("gears")
local naughty = require("naughty")

local orientation_watcher = {}

local last_orientation = nil

-- Function to extract just the string value from the gdbus output
local function parse_orientation(stdout)
	local match = stdout:match("<'(.-)'>")
	return match
end

-- Timer to poll the orientation every second
gears.timer({
	timeout = 1,
	autostart = true,
	callback = function()
		awful.spawn.easy_async_with_shell(
			"gdbus call --system --dest net.hadess.SensorProxy "
				.. "--object-path /net/hadess/SensorProxy "
				.. "--method org.freedesktop.DBus.Properties.Get "
				.. "net.hadess.SensorProxy AccelerometerOrientation",
			function(stdout)
				local orientation = parse_orientation(stdout)
				if orientation and orientation ~= last_orientation then
					last_orientation = orientation

					-- Emit a signal you can use elsewhere
					awesome.emit_signal("sensor::orientation", orientation)

					-- Optional: Show a popup for debugging
					naughty.notify({
						title = "Orientation Changed",
						text = orientation,
						timeout = 2,
					})
				end
			end
		)
	end,
})

return orientation_watcher
