-- Catppuccin Mocha colourscheme, configured to match the tmux catppuccin theme.
-- Integrations tell catppuccin how to colour specific plugins (gitsigns,
-- telescope, etc.) using its palette rather than those plugins' own defaults.
return {
  {
    "catppuccin/nvim",
    name     = "catppuccin",
    priority = 1000, -- load before all other plugins so the theme is ready first
    opts = {
      flavour = "mocha",
      integrations = {
        cmp        = true,
        gitsigns   = true,
        treesitter = true,
        which_key  = true,
        mini       = { enabled = true },
        telescope  = { enabled = true },
        native_lsp = {
          enabled = true,
          underlines = {
            errors       = { "undercurl" },
            hints        = { "undercurl" },
            warnings     = { "undercurl" },
            information  = { "undercurl" },
          },
        },
      },
    },
  },
  -- Tell LazyVim to activate catppuccin as the global colourscheme.
  {
    "LazyVim/LazyVim",
    opts = { colorscheme = "catppuccin" },
  },
}
