return {
  'kevinhwang91/nvim-ufo',
  dependencies = 'kevinhwang91/promise-async',
  config = function()
    local keymap = vim.keymap
    local ufo = require 'ufo'

    vim.o.foldcolumn = '1'
    vim.o.foldlevel = 99
    vim.o.foldlevelstart = 99
    vim.o.foldenable = true

    keymap.set('n', 'zR', ufo.openAllFolds, { desc = 'Open all fold' })
    keymap.set('n', 'zM', ufo.openAllFolds, { desc = 'Open all fold' })
    keymap.set('n', 'zK', function()
      local winid = ufo.peekFoldedLinesUnderCursor()
      if not winid then
        vim.lsp.buf.hover()
      end
    end, { desc = 'Open all fold' })

    ufo.setup {
      provider_selector = function()
        return { 'lsp', 'indent' }
      end,
    }
  end,
}
