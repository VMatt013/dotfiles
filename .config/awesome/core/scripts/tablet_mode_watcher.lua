local awful = require("awful")
local debug = require("core.utils.debug")

local last_line = ""


awful.spawn.with_line_callback(
	"stdbuf -oL -eL libinput debug-events --device /dev/input/by-path/platform-thinkpad_acpi-event",
	{

		stdout = function(line)
			local state = line:match("state%s+(%d)$")
			local last_state = last_line:match("state%s+(%d)$")

			if state and state == last_state then
				return
			end
			if state == "1" then
				awesome.emit_signal("tablet_mode::changed", true)
			elseif state == "0" then
				awesome.emit_signal("tablet_mode::changed", false)
			end

			last_line = line
		end,

		stderr = function(err)
			if err and err ~= "" then
				debug("tablet_mode_watcher error", err)
			end
		end,
	}
)
