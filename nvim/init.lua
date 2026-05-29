-- Set leader keys before lazy.nvim loads.
-- LazyVim defaults to <Space>; overriding here ensures our value wins
-- because this file is sourced before any plugin configuration runs.
vim.g.mapleader      = ","
vim.g.maplocalleader = ","

-- Bootstrap lazy.nvim, LazyVim, and all plugins.
require("config.lazy")
