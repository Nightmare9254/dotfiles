return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    local lualine = require 'lualine'

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

    local harpoon = require 'harpoon'
    local function harpoon_file()
      local marks_length = harpoon:list():length()
      local current_file_path = vim.fn.fnamemodify(vim.fn.expand '%:p', ':.')

      local mark_idx = '-'
      for index = 1, marks_length do
        local harpoon_file_path = harpoon:list():get(index).value

        if current_file_path == harpoon_file_path then
          mark_idx = tostring(index)
        end
      end
      return string.format('↗ %s/%d', mark_idx, marks_length)
    end

    -- configure lualine with modified theme
    lualine.setup {
      options = {
        theme = my_lualine_theme,
      },
      sections = {
        lualine_b = {
          { 'branch', icon = '' },
          harpoon_file,
          'diff',
          'diagnostics',
        },
      },
    }
  end,
}
