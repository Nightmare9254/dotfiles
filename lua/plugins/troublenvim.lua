return {
  'folke/trouble.nvim',
  opts = {}, -- for default options, refer to the configuration section for custom setup.
  cmd = 'Trouble',
  dependencies = { 'nvim-tree/nvim-web-devicons', 'folke/todo-comments.nvim' },
  keys = {
    {
      '<leader>xx',
      '<cmd>Trouble diagnostics toggle<cr>',
      desc = 'Open/close trouble list',
    },
    {
      '<leader>xw',
      '<cmd>Trouble wdiagnostics toggle<cr>',
      desc = 'Open trouble workspace diagnostics',
    },
    { '<leader>xd', '<cmd>Trouble document_diagnostics toggle<cr>', desc = 'Open trouble document diagnostics' },
    {
      '<leader>xq',
      '<cmd>Trouble qflist toggle<cr>',
      desc = 'Quickfix List (Trouble)',
    },
    {
      '<leader>xl',
      '<cmd>Trouble loclist toggle<cr>',
      desc = 'Location List (Trouble)',
    },
    { '<leader>xt', '<cmd>TodoTrouble<CR>', desc = 'Open todos in trouble' },
  },
}
