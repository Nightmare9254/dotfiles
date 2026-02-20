-- options to `gitsigns.nvim`. This is equivalent to the following Lua:
--    require('gitsigns').setup({ ... })
--
-- See `:help gitsigns` to understand what the configuration keys do
-- Here is a more advanced example where we pass configuration
-- options to `gitsigns.nvim`. This is equivalent to the following Lua:
--    require('gitsigns').setup({ ... })
--
-- See `:help gitsigns` to understand what the configuration keys do
-- Adds git related signs to the gutter, as well as utilities for managing changes

return {
  'lewis6991/gitsigns.nvim',
  config = function()
    require('gitsigns').setup {
      signs = {
        add = {
          text = '+',
        },
        change = {
          text = '~',
        },
        delete = {
          text = '_',
        },
        topdelete = {
          text = '‾',
        },
        changedelete = {
          text = '±',
        },
      },
      current_line_blame_formatter = '<author>, <author_time:%R> - <summary>',
      current_line_blame = true,
      current_line_blame_opts = {
        delay = 300,
      },
      diff_opts = {
        ignore_whitespace = true,
        ignore_whitespace_change = true,
        ignore_whitespace_change_at_eol = true,
      },
    }

    vim.keymap.set('n', '<leader>gp', ':Gitsigns preview_hunk<CR>', { desc = '[G]it hunk [P]review' })
  end,
}
