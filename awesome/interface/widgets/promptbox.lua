local awful = require("awful")
local Debug = require("Debug")
local prompt_widget = awful.widget.prompt({
	prompt = "Run: ",
})

local original_run = prompt_widget.run
prompt_widget.run = function(...)
	prompt_widget:emit_signal_recursive("wrap::show")
	original_run(...)
end

return prompt_widget
