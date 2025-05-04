-- core/keybinds/init.lua

local global = require("core.keybinds.global")
local client = require("core.keybinds.client")

local M = {}

M.get_global_keys = global.get_keys
M.get_client_keys = client.get_keys

return M
