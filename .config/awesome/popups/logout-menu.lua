local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")

local ICON_DIR = require("icons")
local SELECTION_COLOR = beautiful.colors.main

local primary_screen = screen.primary or awful.screen.focused()

local popup = awful.popup({
	screen = primary_screen, -- Set the popup to appear on the primary screen
	ontop = true,
	visible = false,
	shape = function(cr, width, height)
		gears.shape.rounded_rect(cr, width, height, 10)
	end,
	placement = awful.placement.centered,
	border_width = 1,
	border_color = beautiful.colors.main,
	widget = {},
})

local rows = { layout = wibox.layout.fixed.vertical }
local selected_index = 1

local args = user_args or {}
local font = args.font or beautiful.font

local onlogout = args.onlogout or function()
	awesome.quit()
end
local onlock = args.onlock or function()
	awful.spawn.with_shell("i3lock")
end
local onreboot = args.onreboot or function()
	awful.spawn.with_shell("/sbin/reboot")
end
local onsuspend = args.onsuspend or function()
	awful.spawn.with_shell("systemctl suspend")
end
local onpoweroff = args.onpoweroff or function()
	awful.spawn.with_shell("/sbin/shutdown now")
end

local onrebootwindows = function()
	awful.spawn.with_shell("sudo efibootmgr -n 0008")
	onreboot()
end

local menu_items = {
	{ name = "Log out", icon_name = "user.svg", command = onlogout },
	{ name = "Lock", icon_name = "lock.svg", command = onlock },
	{ name = "Reboot", icon_name = "reload.svg", command = onreboot },
	{ name = "Reboot to Windows", icon_name = "windows.svg", command = onrebootwindows },
	{ name = "Suspend", icon_name = "moon.svg", command = onsuspend },
	{ name = "Power off", icon_name = "power.svg", command = onpoweroff },
}

local function update_selection()
	for i, row in ipairs(rows) do
		if i == selected_index then
			row.bg = SELECTION_COLOR
		elseif selected_index == 0 then
			row.bg = (row.hovered and beautiful.bg_focus) or beautiful.bg_focus
		else
			row.bg = beautiful.bg_normal
		end
	end
end

for index, item in ipairs(menu_items) do
	local row = wibox.widget({
		{
			{
				{
					image = ICON_DIR .. item.icon_name,
					resize = false,
					widget = wibox.widget.imagebox,
				},
				{
					text = item.name,
					font = font,
					widget = wibox.widget.textbox,
				},
				spacing = 12,
				layout = wibox.layout.fixed.horizontal,
			},
			forced_width = 300,
			margins = 8,
			layout = wibox.container.margin,
		},
		bg = beautiful.bg_normal,
		widget = wibox.container.background,
	})

	row:connect_signal("mouse::enter", function()
		selected_index = index
		row.hovered = true
		update_selection()
	end)

	row:connect_signal("mouse::leave", function()
		row.hovered = false
		if selected_index ~= index then
			update_selection()
		end
	end)

	row:buttons(awful.util.table.join(awful.button({}, 1, function()
		popup.visible = false
		item.command()
	end)))

	table.insert(rows, row)
end

popup:setup(rows)

function popup:toggle()
	self.visible = not self.visible
end

local function handle_key(key)
	if key == "Up" then
		selected_index = (selected_index - 2) % #menu_items + 1
	elseif key == "Down" then
		selected_index = selected_index % #menu_items + 1
	elseif key == "Return" or key == "Right" then
		popup.visible = false
		menu_items[selected_index].command()
	end
	update_selection()
end

popup:connect_signal("property::visible", function()
	if popup.visible then
		awful.keygrabber.run(function(_, key, event)
			if event == "release" then
				return
			end
			if key == "Escape" then
				popup.visible = false
				awful.keygrabber.stop()
			else
				handle_key(key)
			end
		end)
	else
		awful.keygrabber.stop()
	end
end)

return popup
