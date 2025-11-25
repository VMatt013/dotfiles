local awful = require("awful")

local CMD = "amixer"
local CMD_CHANGE = CMD .. " sset Master "
local STEP = "1%"
local CMD_GET = CMD .. " sget Master"

awesome.connect_signal("utils::volume::increase", function(popup)
	awful.spawn.with_shell(CMD_CHANGE .. STEP .. "+")

	if popup then
		awful.spawn.easy_async_with_shell(CMD_GET, function(stdout)
			local volume = stdout:match("%[(%d+)%%%]")
			awesome.emit_signal("popups::volume", tonumber(volume))
		end)
	end
end)

awesome.connect_signal("utils::volume::decrease", function(popup)
	awful.spawn.with_shell(CMD_CHANGE .. STEP .. "-")

	if popup then
		awful.spawn.easy_async_with_shell(CMD_GET, function(stdout)
			local volume = stdout:match("%[(%d+)%%%]")
			awesome.emit_signal("popups::volume", tonumber(volume))
		end)
	end
end)

awesome.connect_signal("utils::volume::get", function(callback)
	awful.spawn.easy_async_with_shell("amixer sget Master", function(stdout)
		local vol = stdout:match("(%d+)%%")
		local mute = stdout:match("%[off%]") and true or false
		if callback then
			callback(tonumber(vol), mute)
		end
	end)
end)
