local awful = require("awful")
local beautiful = require("beautiful")
local ruled = require("ruled")

ruled.notification.connect_signal("request::rules", function()
	-- All notifications will match this rule.
	ruled.notification.append_rule({
		rule = {},
		properties = {
			screen = awful.screen.preferred,
			implicit_timeout = 5,
		},
	})
end)

rules = {
	-- All clients will match this rule.
	{
		rule = {},
		properties = {
			focus = awful.client.focus.filter,
			raise = true,
			keys = clientkeys,
			buttons = clientbuttons,
			screen = awful.screen.preferred,
			shape = beautiful.shape.rounded_rect(beautiful.dpi),
			placement = awful.placement.no_overlap + awful.placement.no_offscreen,
		},
	},

	-- Floating clients.
	{
		rule_any = {
			instance = {
				"DTA", -- Firefox addon DownThemAll.
				"copyq", -- Includes session name in class.
				"pinentry",
			},
			class = {
				"Arandr",
				"Blueman-manager",
				"Gpick",
				"Kruler",
				"MessageWin", -- kalarm.
				"Sxiv",
				"Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
				"Wpa_gui",
				"veromix",
				"xtightvncviewer",
			},

			-- Note that the name property shown in xprop might be set slightly after creation of the client
			-- and the name shown there might not match defined rules here.
			name = {
				"Event Tester", -- xev.
			},
			role = {
				"AlarmWindow", -- Thunderbird's calendar.
				"ConfigManager", -- Thunderbird's about:config.
				--"pop-up", -- e.g. Google Chrome's (detached) Developer Tools.
			},
		},
		properties = { floating = true },
	},

	-- Add titlebars to normal clients and dialogs
	{ rule_any = { type = { "normal", "dialog" } }, properties = { titlebars_enabled = beautiful.titlebars_enable } },

	{ rule = { class = "Zen Browser" }, properties = { screen = 1, tag = "3" } },
	{ rule = { name = "Onboard" }, properties = { focusable = false } },

	{
		rule = { instance = "Toolkit", role = "PictureInPicture" },
		properties = {
			floating = true,
			titlebars_enabled = true,
		},
	},
	{
		rule = { class = "scrcpy" },
		properties = {
			floating = true,
			titlebars_enabled = true,
			sticky = true,
		},
	},
	-- Add this to your rules section
}

return rules
