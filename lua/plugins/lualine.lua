return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    local lualine = require 'lualine'
    local lazy_status = require 'lazy.status' -- to configure lazy pending updates count

    local C = require('catppuccin.palettes').get_palette 'mocha'
    local O = require('catppuccin').options
    local transparent_bg = O.transparent_background and 'NONE' or C.mantle

    local my_lualine_theme = {
      normal = {
        a = { bg = C.blue, fg = C.mantle, gui = 'bold' },
        b = { bg = C.surface0, fg = C.blue },
        c = { bg = transparent_bg, fg = C.text },
      },
      insert = {
        a = { bg = C.green, fg = C.base, gui = 'bold' },
        b = { bg = C.surface0, fg = C.green },
      },
      visual = {
        a = { bg = C.mauve, fg = C.base, gui = 'bold' },
        b = { bg = C.surface0, fg = C.mauve },
      },
      command = {
        a = { bg = C.peach, fg = C.base, gui = 'bold' },
        b = { bg = C.surface0, fg = C.peach },
      },
      terminal = {
        a = { bg = C.green, fg = C.base, gui = 'bold' },
        b = { bg = C.surface0, fg = C.green },
      },

      replace = {
        a = { bg = C.red, fg = C.base, gui = 'bold' },
        b = { bg = C.surface0, fg = C.red },
      },
      inactive = {
        a = { bg = transparent_bg, fg = C.blue },
        b = { bg = transparent_bg, fg = C.surface1, gui = 'bold' },
        c = { bg = transparent_bg, fg = C.overlay0 },
      },
    }

    -- configure lualine with modified theme
    lualine.setup {
      options = {
        theme = my_lualine_theme,
      },
    }
  end,
}
