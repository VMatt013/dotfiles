local awful = require("awful")
local popup = require("popups.volume")

local CMD = "amixer"
local CMD_CHANGE = CMD .. " sset Master "
local STEP = 1
local MIN = 0
local MAX = 100

local volume = 50
local isMuted = false

local util = {}

function util:update()
	awful.spawn.with_shell(CMD_CHANGE .. volume .. "%")
end

function util:get_system_volume()
	awful.spawn.easy_async_with_shell("amixer sget Master", function(stdout)
		volume = stdout:match("(%d?%d?%d)%%")
		--isMuted = stdout:match("%[off%]")
	end)
end

function util:get_volume()
	return volume
end

function util:up_without_popup()
	if volume + STEP <= MAX then
		volume = volume + STEP
	end
	util:update()
end

function util:up()
	if volume + STEP <= MAX then
		volume = volume + STEP
	end
	util:update()
	popup:update(volume)
end

function util:down_without_popup()
	if volume - STEP >= MIN then
		volume = volume - STEP
	end
	util:update()
end

function util:down()
	if volume - STEP >= MIN then
		volume = volume - STEP
	end

	util:update()
	popup:update(volume)
end

return util
