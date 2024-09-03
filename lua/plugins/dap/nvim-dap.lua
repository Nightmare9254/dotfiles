return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'rcarriga/nvim-dap-ui',
  },
  config = function()
    local keymap = vim.keymap -- for conciseness
    local dap = require 'dap'

    keymap.set('n', '<leader>db', dap.toggle_breakpoint, { desc = 'Ad[D] [B]reakpoint' })
    keymap.set('n', '<leader>dc', dap.continue, { desc = '[D]ap [C]ontinue' })

    keymap.set('n', '<leader>bc', "<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>")
    keymap.set('n', '<leader>bl', "<cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<cr>")
    keymap.set('n', '<leader>br', "<cmd>lua require'dap'.clear_breakpoints()<cr>")
    keymap.set('n', '<leader>ba', '<cmd>Telescope dap list_breakpoints<cr>')
    keymap.set('n', '<leader>dj', "<cmd>lua require'dap'.step_over()<cr>")
    keymap.set('n', '<leader>dk', "<cmd>lua require'dap'.step_into()<cr>")
    keymap.set('n', '<leader>do', "<cmd>lua require'dap'.step_out()<cr>")
    keymap.set('n', '<leader>dd', function()
      require('dap').disconnect()
      require('dapui').close()
    end)
    keymap.set('n', '<leader>dt', function()
      require('dap').terminate()
      require('dapui').close()
    end)
    keymap.set('n', '<leader>dr', "<cmd>lua require'dap'.repl.toggle()<cr>")
    keymap.set('n', '<leader>dl', "<cmd>lua require'dap'.run_last()<cr>")
    keymap.set('n', '<leader>di', function()
      require('dap.ui.widgets').hover()
    end)
    keymap.set('n', '<leader>d?', function()
      local widgets = require 'dap.ui.widgets'
      widgets.centered_float(widgets.scopes)
    end)
    keymap.set('n', '<leader>df', '<cmd>Telescope dap frames<cr>')
    keymap.set('n', '<leader>dh', '<cmd>Telescope dap commands<cr>')
    keymap.set('n', '<leader>de', function()
      require('telescope.builtin').diagnostics { default_text = ':E:' }
    end)
  end,
}
