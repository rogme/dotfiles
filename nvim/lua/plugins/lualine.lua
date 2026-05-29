-- Lualine status line — catppuccin mocha "bubbles" style.
--
-- The key to the floating-pill look is setting section 'c' (and 'x') to use
-- the editor background colour (c.base). This makes the middle of the bar
-- transparent, so the coloured pills on the left and right appear to float
-- rather than forming a continuous bar.
--
-- Section separators U+E0B4 / U+E0B6 are the Nerd Fonts rounded half-circles
-- that cap each pill. Component separators are cleared so there are no inner
-- dividers within a section.
return {
  "nvim-lualine/lualine.nvim",
  opts = function(_, opts)
    local ok, cp = pcall(require, "catppuccin.palettes")
    if not ok then return opts end
    local c = cp.get_palette("mocha")

    opts.options = vim.tbl_extend("force", opts.options or {}, {
      theme = {
        -- Mode colours match catppuccin conventions.
        normal   = { a = { fg = c.base, bg = c.blue,  gui = "bold" }, b = { fg = c.blue,  bg = c.surface0 }, c = { fg = c.text, bg = c.base } },
        insert   = { a = { fg = c.base, bg = c.green, gui = "bold" }, b = { fg = c.green, bg = c.surface0 }, c = { fg = c.text, bg = c.base } },
        visual   = { a = { fg = c.base, bg = c.mauve, gui = "bold" }, b = { fg = c.mauve, bg = c.surface0 }, c = { fg = c.text, bg = c.base } },
        replace  = { a = { fg = c.base, bg = c.red,   gui = "bold" }, b = { fg = c.red,   bg = c.surface0 }, c = { fg = c.text, bg = c.base } },
        command  = { a = { fg = c.base, bg = c.peach, gui = "bold" }, b = { fg = c.peach, bg = c.surface0 }, c = { fg = c.text, bg = c.base } },
        inactive = { a = { fg = c.text, bg = c.base  }, b = { fg = c.text, bg = c.base }, c = { fg = c.text, bg = c.base } },
      },
      section_separators   = { left = "\xEE\x82\xB4", right = "\xEE\x82\xB6" }, -- U+E0B4 / U+E0B6
      component_separators = "",
    })
    return opts
  end,
}
