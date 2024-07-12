return {
  -- https://github.com/mfussenegger/nvim-dap-python
  'mfussenegger/nvim-dap-python',
  ft = 'python',
  dependencies = {
    -- https://github.com/mfussenegger/nvim-dap
    'mfussenegger/nvim-dap',
    'rcarriga/nvim-dap-ui',
  },
  config = function()
    -- Update the path passed to setup to point to your system or virtual env python binary
    require('dap-python').setup '~/.local/share/nvim/mason/packages/debugpy/venv/bin/python'
  end,
}
