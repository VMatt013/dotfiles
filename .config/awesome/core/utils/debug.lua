local naughty = require("naughty")
-- Function to pretty-print a table
function tprint(tbl, indent)
	if not indent then
		indent = 0
	end
	local toprint = string.rep(" ", indent) .. "{\r\n"
	indent = indent + 2
	for k, v in pairs(tbl) do
		toprint = toprint .. string.rep(" ", indent)
		if type(k) == "number" then
			toprint = toprint .. "[" .. k .. "] = "
		elseif type(k) == "string" then
			toprint = toprint .. k .. "= "
		end
		if type(v) == "number" then
			toprint = toprint .. v .. ",\r\n"
		elseif type(v) == "string" then
			toprint = toprint .. '"' .. v .. '",\r\n'
		elseif type(v) == "table" then
			toprint = toprint .. tprint(v, indent + 2) .. ",\r\n"
		else
			toprint = toprint .. '"' .. tostring(v) .. '",\r\n'
		end
	end
	toprint = toprint .. string.rep(" ", indent - 2) .. "}"
	return toprint
end

-- Function to notify with a title and message, optionally printing a table
local function debug(title, msg, tbl, indent)
	if not title then
		title = "Debug"
	end
	if not msg then
		msg = ""
	end
	local text = tostring(msg)
	if tbl then
		if indent then
			tprint(tbl)
		else
			for k, v in pairs(tbl) do
				debug(k, v)
			end
		end
	else
		naughty.notify({ title = tostring(title), text = text, timeout = 0 })
	end
end
return debug
