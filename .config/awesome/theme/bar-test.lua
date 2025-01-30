local gears = require("gears")

local theme = {}

theme.colors = {
	main = "#811d5888",
	text = "#ffffff",
	secondary = "#000000",
	bg = "#ff888099",
	border = "#000000",
	taglist = {
		selected = "#D1345B",
		active = "#34D1BF",
		inactive = "#efefef",
	},
}

theme.dpi = 20

theme.wallpapers = { "/home/matt/wallpapers/eclipse.jpg", "/home/matt/wallpapers/eva.jpg" }

theme.icons = { sound = { "󰖁 ", "󰕿 ", "󰖀 ", "󰕾 " } }

theme.font = "Hack Nerd Font"

theme.rects = {
	rounded = function(rad)
		rad = rad or 5
		return function(cr, width, height)
			gears.shape.rounded_rect(cr, width, height, rad)
		end
	end,

	rectangle = function()
		return function(cr, width, height)
			gears.shape.rectangle(cr, width, height)
		end
	end,
}

theme.bar = {
	border_width = 3,
	border_color = theme.colors.border,
	position = "top",
	height = 25,
	margins = {
		top = 0,
		bottom = 0,
		left = 0,
		right = 0,
	},
	bg = theme.colors.main,
	fg = theme.colors.text,
	shape = theme.rects.rectangle(),
}

theme.titlebar = {
	size = 25,
	bg_normal = theme.colors.main,
	bg_focus = theme.colors.main,
	h_margin = 15,
	v_margin = 1,
}

theme.client = {
	border_width = 3,
	border_color = theme.colors.border,
}

return theme
