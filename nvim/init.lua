-- NOTE: the leader is set in lua/config/options.lua, not here. LazyVim's default
-- options run during lazy setup (after this file) and would overwrite a leader
-- set here, so setting it in config/options.lua is the place that actually sticks.

-- Bootstrap lazy.nvim, LazyVim, and all plugins.
require("config.lazy")
