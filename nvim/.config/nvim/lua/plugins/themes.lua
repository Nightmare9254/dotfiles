return {
  -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
  'catppuccin/nvim',
  priority = 1000, -- Make sure to load this before all the other start plugins.
  init = function()
    require('catppuccin').setup {
      integrations = {
        cmp = true,
        fidget = true,
        gitsigns = true,
        harpoon = true,
        indent_blankline = {
          enabled = false,
          scope_color = 'sapphire',
          colored_indent_levels = false,
        },
        mason = true,
        native_lsp = { enabled = true },
        noice = true,
        notify = true,
        symbols_outline = true,
        telescope = true,
        treesitter = true,
        treesitter_context = true,
      },
    }
    -- Load the colorscheme here.
    -- Like many other themes, this one has different styles, and you could load
    vim.cmd.colorscheme 'catppuccin-mocha'

    -- You can configure highlights by doing something like:
    vim.cmd.hi 'Comment gui=none'
  end,
}
