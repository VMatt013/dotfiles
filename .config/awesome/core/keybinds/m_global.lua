-- core/keybinds/m_global.lua

local awful = require("awful")
local gears = require("gears")

local M = {}

M.get_keys = function()
	return gears.table.join(awful.button({}, 3, function()
		-- mymainmenu:toggle() -- Uncomment if using the default menu
	end))
end

return M
