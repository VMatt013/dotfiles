-- core/keybinds/init.lua

local global = require("core.keybinds.global")
local client = require("core.keybinds.client")
local m_client = require("core.keybinds.m_client")
local m_global = require("core.keybinds.m_global")

local M = {}

M.get_global_keys = global.get_keys
M.get_client_keys = client.get_keys
M.get_m_client_keys = m_client.get_keys
M.get_m_global_keys = m_global.get_keys

return M
