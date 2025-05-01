local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")

local dpi = beautiful.xresources.apply_dpi

local helpers = require("helpers")
local theme = require("theme.bar-test")
local color = theme.colors.taglist
local font = theme.font
local font_size = 12

local function create(s)
	-- Define taglist buttons
	local taglist_buttons = gears.table.join(
		awful.button({}, 1, function(t)
			t:view_only()
		end),
		awful.button({ modkey }, 1, function(t)
			if client.focus then
				client.focus:move_to_tag(t)
			end
		end),
		awful.button({}, 3, awful.tag.viewtoggle),
		awful.button({ modkey }, 3, function(t)
			if client.focus then
				client.focus:toggle_tag(t)
			end
		end),
		awful.button({}, 4, function(t)
			awful.tag.viewnext(t.screen)
		end),
		awful.button({}, 5, function(t)
			awful.tag.viewprev(t.screen)
		end)
	)

	local update_tag = function(self, c3, _)
		if c3.selected then
			self:get_children_by_id("tags")[1].markup = helpers.mtext(color.selected, font .. " " .. font_size, "󰪥")
		elseif #c3:clients() == 0 then
			self:get_children_by_id("tags")[1].markup = helpers.mtext(color.inactive, font .. " " .. font_size, "")
		else
			self:get_children_by_id("tags")[1].markup = helpers.mtext(color.active, font .. " " .. font_size, "")
		end
	end

	-- Create a taglist widget
	local taglist = awful.widget.taglist({
		screen = s,
		filter = awful.widget.taglist.filter.all,
		layout = { layout = wibox.layout.fixed.horizontal, spacing = dpi(10), shape = gears.shape.circle },
		style = { font = font .. " " .. font_size .. " bold" },
		widget_template = {
			id = "tags",
			widget = wibox.widget.textbox,
			markup = helpers.mtext(color.inactive, font .. " " .. font_size, ""),
			forced_width = dpi(15),
			create_callback = function(self, c3, _)
				update_tag(self, c3, _)
			end,
			update_callback = function(self, c3, _)
				update_tag(self, c3, _)
			end,
		},

		buttons = taglist_buttons,
	})

	-- Create a wibox container for the taglist with rounded corners
	local rounded_taglist = wibox.widget({
		{
			taglist,
			top = 0,
			bottom = 0,
			left = 5,
			right = 5,

			widget = wibox.container.margin,
		},
		bg = beautiful.bg_normal,
		shape = gears.shape.rounded_rect,
		widget = wibox.container.background,
	})

	return rounded_taglist
end

return create
