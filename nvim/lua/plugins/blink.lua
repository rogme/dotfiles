-- ~/.config/nvim/lua/plugins/blink.lua
return {
  "saghen/blink.cmp",
  opts = {
    keymap = {
      preset = "none",
      ["<Tab>"]   = { "select_next", "snippet_forward", "fallback" },
      ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
      ["<C-n>"]   = { "select_next", "fallback" },
      ["<C-p>"]   = { "select_prev", "fallback" },
      ["<CR>"]    = { "accept", "fallback" },
      ["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
      ["<C-e>"]   = { "hide", "fallback" },
      ["<C-b>"]   = { "scroll_documentation_up" },
      ["<C-f>"]   = { "scroll_documentation_down" },
    },
    completion = {
      list = {
        selection = {
          -- Ensures Tab cycles through rather than only inserting the 1st result automatically
          preselect = false,
          auto_insert = true,
        },
      },
    },
  },
}
