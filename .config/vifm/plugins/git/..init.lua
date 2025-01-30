local M = {}
local layer_id = "vifm-preview"
local pipe_storage
local cache_path_storage

local function get_pipe()
	if pipe_storage == nil then
		local cmd
		if vifm.executable("cat") then
			cmd = "cat"
		else
			return nil, "git executable isn't found"
		end

		local git = vifm.startjob({
			cmd = cmd,
		})
		pipe_storage = git:stdin()
	end
	return pipe_storage
end

local function clear(info)
	local pipe, err = get_pipe()
	if pipe == nil then
		return { lines = { err } }
	end

	local format = '{"action":"remove", "identifier":"%s"}\n'
	local message = format:format(layer_id)
	pipe:write(message)
	pipe:flush()
	return { lines = {} }
end

local function view(info)
	local pipe, err = get_pipe()
	if pipe == nil then
		return { lines = { err } }
	end

	local format = '{"action":"add", "identifier":"%s"}\n'
	local message = format:format(layer_id)
	pipe:write(message)
	pipe:flush()

	return { lines = {} }
end

local function log(info)
	return view(info)
end

local function status(info)
	return view(info)
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
	vifm.sb.error("Failed to register :ststatuss")
end

handle({ name = "log", handler = log })
handle({ name = "status", handler = status })
handle({ name = "clear", handler = clear })

return M
