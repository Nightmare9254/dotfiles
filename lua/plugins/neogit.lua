return {
  'NeogitOrg/neogit',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'sindrets/diffview.nvim',

    'nvim-telescope/telescope.nvim',
    'ibhagwan/fzf-lua',
  },
  config = function()
    local neogit = require 'neogit'
    vim.keymap.set('n', '<leader>gn', function()
      neogit.open()
    end, {
      desc = '[G]it [N]eogit',
    })
    neogit.setup {}
  end,
}
