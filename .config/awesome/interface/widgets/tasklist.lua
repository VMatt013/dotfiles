-- tasklist.lua

local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")

-- Mouse bindings for the tasklist
local tasklist_buttons = gears.table.join(
	awful.button({}, 1, function(c)
		if c == client.focus then
			c.minimized = true
		else
			c:emit_signal("request::activate", "tasklist", { raise = true })
		end
	end),
	awful.button({}, 3, function()
		awful.menu.client_list({ theme = { width = 250 } })
	end),
	awful.button({}, 4, function()
		awful.client.focus.byidx(1)
	end),
	awful.button({}, 5, function()
		awful.client.focus.byidx(-1)
	end)
)

local function create(s, max_width)
	local max_width = max_width or 300
	local tasklist_widget = awful.widget.tasklist({
		screen = s,
		filter = awful.widget.tasklist.filter.currenttags,
		buttons = tasklist_buttons,
		style = {
			shape = gears.shape.rounded_bar,
			oppacity = 0,
		},
		layout = {
			spacing = 5,
			layout = wibox.layout.flex.horizontal,
		},
		widget_template = {
			{
				{
					{
						{
							{
								id = "clienticon",
								widget = awful.widget.clienticon,
							},
							margins = 2,
							widget = wibox.container.margin,
						},
						{
							id = "text_role",
							widget = wibox.widget.textbox,
						},
						layout = wibox.layout.fixed.horizontal,
					},
					left = 10,
					right = 10,
					widget = wibox.container.margin,
				},
				id = "background_role",
				widget = wibox.container.background,
			},
			widget = wibox.container.margin,
			top = 2,
			bottom = 2,
		},
	})

	local tasklist_constraint = wibox.container.constraint(tasklist_widget, "max", max_width)
	local function update_tasklist_visibility()
		local clients = awful.screen.focused().clients
		local visible_clients = 0
		for _, c in pairs(clients) do
			if c.first_tag.selected then
				visible_clients = visible_clients + 1
			end
		end

		if visible_clients > 0 then
			tasklist_widget:emit_signal_recursive("wrap::show")
		else
			tasklist_widget:emit_signal_recursive("wrap::hide")
		end
	end

	-- Connect to client signals to update the visibility
	client.connect_signal("manage", update_tasklist_visibility)
	client.connect_signal("unmanage", update_tasklist_visibility)
	client.connect_signal("tagged", update_tasklist_visibility)
	client.connect_signal("untagged", update_tasklist_visibility)

	-- Connect to tag signals to update the visibility
	tag.connect_signal("property::selected", update_tasklist_visibility)

	-- Initial check
	update_tasklist_visibility()

	return tasklist_constraint
end

return create
