-- User options — loaded before lazy.nvim starts.
-- LazyVim's own defaults are at:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua

local opt = vim.opt

-- Indentation: 4-space indent with spaces-only (overrides LazyVim's 2-space default).
-- Matches Python PEP 8 and most C++ style guides.
opt.tabstop     = 4
opt.shiftwidth  = 4
opt.softtabstop = 4
opt.expandtab   = true

opt.scrolloff     = 8    -- keep 8 lines of context above/below cursor
opt.sidescrolloff = 8    -- keep 8 columns of context when scrolling horizontally
opt.wrap          = false
opt.colorcolumn   = "120"
opt.cursorline    = true
