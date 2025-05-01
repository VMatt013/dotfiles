local laptop = require("interface.bar.modes.laptop")
local tablet_vertical = require("interface.bar.modes.tablet-vertical")
local tablet_horizontal = require("interface.bar.modes.tablet-horizontal")

return {
	["laptop"] = laptop,
	["laptop-vertical"] = tablet_vertical,
	["laptop-horizontal"] = tablet_horizontal,
}
