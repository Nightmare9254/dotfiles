return {
  {
    'echasnovski/mini.indentscope',
    version = false,
    event = 'BufEnter',
    opts = {
      symbol = '│',
      options = { try_as_border = true },
      -- draw = { animation = require('mini.indentscope').gen_animation.none() },
    },
    init = function()
      local macchiato = require('catppuccin.palettes').get_palette 'mocha'
      vim.api.nvim_create_autocmd('FileType', {
        pattern = {
          'help',
          'lazy',
          'mason',
          'notify',
        },
        callback = function()
          vim.b.miniindentscope_disable = true
        end,
      })

      vim.api.nvim_set_hl(0, 'MiniIndentscopeSymbol', { fg = macchiato.mauve })
    end,
  },
}
