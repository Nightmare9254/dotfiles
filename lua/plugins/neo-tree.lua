return {
  'nvim-tree/nvim-tree.lua',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  config = function()
    local nvimtree = require 'nvim-tree'

    -- recommended settings from nvim-tree documentation
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    nvimtree.setup {
      view = {
        width = 35,
        relativenumber = true,
      },
      -- change folder arrow icons
      renderer = {
        indent_markers = {
          enable = true,
        },
        icons = {
          glyphs = {
            folder = {
              arrow_closed = '', -- arrow when folder is closed
              arrow_open = '', -- arrow when folder is open
            },
          },
        },
      },
      -- disable window_picker for
      -- explorer to work well with
      -- window splits
      --  actions = {
      --
      --   open_file = {
      --   window_picker = {
      --   enable = false,
      --},
      --},
      --},
      filters = {
        custom = { '.DS_Store' },
      },
      git = {
        ignore = false,
      },
    }

    -- set keymaps
    local keymap = vim.keymap -- for conciseness

    keymap.set('n', '<leader>ee', '<cmd>NvimTreeToggle<CR>', { desc = 'Toggle file [E]xplorer' }) -- toggle file explorer
    keymap.set('n', '<leader>ef', '<cmd>NvimTreeFindFile<CR>', { desc = 'Toggle file [E]xplorer on current [F]ile' }) -- toggle file explorer on current file
    keymap.set('n', '<leader>ec', '<cmd>NvimTreeCollapse<CR>', { desc = '[E]xplorer [C]ollapse' }) -- collapse file explorer
    keymap.set('n', '\\', '<cmd>NvimTreeToggle<CR>', { desc = 'Toggle file explorer using [\\]' }) -- toggle file explorer
    keymap.set('n', '<leader>er', '<cmd>NvimTreeRefresh<CR>', { desc = '[Explorer] [R]efresh' }) -- refresh file explorer
  end,
}
