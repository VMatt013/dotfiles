-- core/keybinds/m_client.lua

local awful = require("awful")
local gears = require("gears")

local M = {}

M.get_keys = function()
	return gears.table.join(
		awful.button({}, 1, function(c)
			c:activate({ context = "mouse_click" })
		end),
		awful.button({ modkey }, 1, function(c)
			c:activate({ context = "mouse_click", action = "mouse_move" })
		end),
		awful.button({ modkey }, 3, function(c)
			c:activate({ context = "mouse_click", action = "mouse_resize" })
		end)
	)
end

return M
