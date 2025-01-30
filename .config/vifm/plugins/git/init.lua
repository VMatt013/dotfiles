local M = {}

local function status()
	vifm.startjob({
		cmd = "au DirEnter '~/Documents/Git/**/*' setl previewprg='git status %d 2>&1'",
	})
end

local function log()
	vifm.startjob({
		cmd = "au DirEnter '~/Documents/Git/**/*' setl previewprg='git log --color %d 2>&1'",
	})
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
	vifm.sb.error("Failed to register :ststatus")
end

return M
