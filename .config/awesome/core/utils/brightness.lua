local awful = require("awful")

local CMD = "light "
local CMD_INC = CMD .. "-A "
local CMD_DEC = CMD .. "-U "
local STEP = 2

awesome.connect_signal("utils::brightness::increase", function()
	awful.spawn.with_shell(CMD_INC .. STEP)
	awful.spawn.easy_async_with_shell(CMD, function(stdout)
		awesome.emit_signal("popups::brightness", tonumber(stdout))
	end)
end)

awesome.connect_signal("utils::brightness::decrease", function()
	awful.spawn.with_shell(CMD_DEC .. STEP)
	awful.spawn.easy_async_with_shell(CMD, function(stdout)
		awesome.emit_signal("popups::brightness", tonumber(stdout))
	end)
end)
