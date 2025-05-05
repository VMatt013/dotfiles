-- awesome_mode: api-level=4:screen=on
-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

local DIR = os.getenv("HOME") .. "/.config/awesome/"

local beautiful = require("beautiful")
local gears = require("gears")
local awful = require("awful")
local naughty = require("naughty")
local hotkeys_popup = require("awful.hotkeys_popup")

require("awful.autofocus")
require("awful.hotkeys_popup.keys")

beautiful.init(DIR .. "interface/theme/" .. "default/theme.lua")

naughty.connect_signal("request::display_error", function(message, startup)
	naughty.notification({
		urgency = "critical",
		title = "Oops, an error happened" .. (startup and " during startup!" or "!"),
		message = message,
	})
end)

terminal = "alacritty"
editor = os.getenv("EDITOR") or "nvim"
editor_cmd = terminal .. " -e " .. editor

modkey = "Mod4"

myawesomemenu = {
	{
		"hotkeys",
		function()
			hotkeys_popup.show_help(nil, awful.screen.focused())
		end,
	},
	{ "manual", terminal .. " -e man awesome" },
	{ "edit config", editor_cmd .. " " .. awesome.conffile },
	{ "restart", awesome.restart },
	{
		"quit",
		function()
			awesome.quit()
		end,
	},
}

mymainmenu = awful.menu({
	items = {
		{ "awesome", myawesomemenu, beautiful.awesome_icon },
		{ "open terminal", terminal },
	},
})

awful.layout.layouts = {
	awful.layout.suit.tile,
	awful.layout.suit.floating,
}

require("interface.bar")

local function set_wallpaper(s)
	if beautiful.wallpapers then
		for s = 1, screen.count() do
			gears.wallpaper.maximized(beautiful.wallpapers[s], s)
		end
	end
end

screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
	set_wallpaper(s)
end)

local keybinds = require("core.keybinds")

root.keys(keybinds.get_global_keys())

client.connect_signal("request::default_keybindings", function()
	awful.keyboard.append_client_keybindings(keybinds.get_client_keys())
end)

awful.mouse.append_global_mousebindings({
	awful.button({}, 3, function()
		mymainmenu:toggle()
	end),
})

client.connect_signal("request::default_mousebindings", function()
	awful.mouse.append_client_mousebindings({
		awful.button({}, 1, function(c)
			c:activate({ context = "mouse_click" })
		end),
		awful.button({ modkey }, 1, function(c)
			c:activate({ context = "mouse_click", action = "mouse_move" })
		end),
		awful.button({ modkey }, 3, function(c)
			c:activate({ context = "mouse_click", action = "mouse_resize" })
		end),
	})
end)

awful.rules.rules = require("core.rules")

client.connect_signal("request::titlebars", require("interface.titlebars"))

naughty.connect_signal("request::display", function(n)
	naughty.layout.box({ notification = n })
end)

client.connect_signal("mouse::enter", function(c)
	c:activate({ context = "mouse_enter", raise = false })
end)

require("core.scripts.tablet_mode_watcher")
require("core.scripts.rotate-screen")
awful.spawn.with_shell(DIR .. "/core/scripts/startup")
