local M = {}

local currview = vifm.currview()
local curr_entry = currview.cursor:entry()
local curr_loc = curr_entry.location
local entries = {}
local entry_pos = {}

if currview.custom == nil or currview.custom.type ~= "tree" then
	for i = 1, currview.entrycount do
		local e = currview:entry(i)
	end
else
	-- limit to location of current entry in tree-view

	local function belongs_to_curr_entry_location(i)
		local e = currview:entry(i)
		if e.location:sub(1, curr_loc:len()) ~= curr_loc then
			return false
		end
		if e.location == curr_loc then
			remember_entry_and_position(e, i)
		end
		return true
	end

	-- gather entries around the cursor
	local i = currview.cursor.pos - 1
	while i >= 1 and belongs_to_curr_entry_location(i) do
		i = i - 1
	end

	local i = currview.cursor.pos + 1
	while i <= currview.entrycount and belongs_to_curr_entry_location(i) do
		i = i + 1
	end
end

local function debug(table)
	local file = io.open("vifm", "w")
	for k, v in pairs(table) do
		file:write("-" .. tostring(k) .. " " .. tostring(v) .. "\n")
	end
	io.close(file)
end

local function get_pipe(command)
	local job = vifm.startjob({
		cmd = string.format("git %s", command),
	})
	for line in job:stdout():lines() do
		--vifm.wm.write(line)
		--vifm.sb.info(string.format(line))
	end
end

local function log(info)
	return view(info, "log")
end

local function status(info)
	return view(info, "status")
end

local function handle(info)
	local added = vifm.addhandler(info)
	if not added then
		vifm.sb.error(string.format("Failed to register #%s#%s", vifm.plugin.name, info.name))
	end
end

local added = vifm.cmds.add({
	name = "log",
	description = "git log",
	handler = log,
	maxargs = 0,
})
if not added then
	vifm.sb.error("Failed to register :log")
end

local added = vifm.cmds.add({
	name = "status",
	description = "git status",
	handler = status,
	maxargs = 0,
})
if not added then
	vifm.sb.error("Failed to register :log")
end

handle({ name = "clear", handler = clear })
handle({ name = "log", handler = log })
handle({ name = "status", handler = status })

return M
