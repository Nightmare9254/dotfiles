-- Example config with lazyvim
return {
  'nvimtools/none-ls.nvim',
  keys = {
    { '<leader>cn', '<cmd>NullLsInfo<cr>', desc = '[C]spell [N]ullLs Info' },
  },
  dependencies = { 'mason.nvim', 'davidmh/cspell.nvim' },
  event = { 'BufReadPre', 'BufNewFile' },
  ft = { 'typescriptreact' },
  opts = function()
    local cspell = require 'cspell'
    local ok, null_ls = pcall(require, 'null-ls')
    if not ok then
      return
    end

    local sources = {
      cspell.diagnostics.with {
        -- Set the severity to HINT for unknown words
        diagnostics_postprocess = function(diagnostic)
          diagnostic.severity = vim.diagnostic.severity['HINT']
        end,
      },
      cspell.code_actions,
      null_ls.builtins.code_actions.eslint_d,
    }
    -- Define the debounce value
    local debounce_value = 200
    return {
      sources = sources,
      debounce = debounce_value,
      debug = true,
    }
  end,
}
