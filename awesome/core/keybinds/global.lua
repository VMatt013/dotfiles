-- core/keybinds/global.lua

local awful = require("awful")
local gears = require("gears")
local hotkeys_popup = require("awful.hotkeys_popup")
local modkey = "Mod4"

local M = {}

M.get_keys = function()
	return gears.table.join(
		awful.key({ modkey }, "s", hotkeys_popup.show_help, { description = "show help", group = "awesome" }),
		awful.key({ modkey }, "Left", awful.tag.viewprev, { description = "view previous", group = "tag" }),
		awful.key({ modkey }, "Right", awful.tag.viewnext, { description = "view next", group = "tag" }),
		awful.key({ modkey }, "Escape", awful.tag.history.restore, { description = "go back", group = "tag" }),

		awful.key({ modkey }, "j", function()
			awful.client.focus.byidx(1)
		end, { description = "focus next by index", group = "client" }),
		awful.key({ modkey }, "k", function()
			awful.client.focus.byidx(-1)
		end, { description = "focus previous by index", group = "client" }),

		awful.key({ modkey, "Control" }, "r", awesome.restart, { description = "reload awesome", group = "awesome" }),
		awful.key({ modkey, "Shift" }, "q", awesome.quit, { description = "quit awesome", group = "awesome" }),

		awful.key({ modkey }, "Return", function()
			awful.spawn("alacritty")
		end, { description = "open a terminal", group = "launcher" }),
		awful.key({ modkey }, "r", function()
			awful.spawn("rofi -show drun")
		end, { description = "run prompt", group = "launcher" })
	)
end

return M
