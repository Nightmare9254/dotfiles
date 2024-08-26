local null_ls = require 'null-ls'
local helpers = require 'null-ls.helpers'

local M = {}

local function read_json_file(path)
  local file = io.open(path, 'r')
  if not file then
    return nil
  end
  local content = file:read '*a'
  file:close()
  return vim.fn.json_decode(content)
end

local function write_json_file(path, content)
  local file = io.open(path, 'w')
  if not file then
    return false
  end
  file:write(vim.fn.json_encode(content))
  file:close()
  return true
end

M.add_word_to_global_cspell = function(word)
  local global_cspell_path = vim.fn.expand '~/.config/nvim/cspell.json'
  local cspell_config = read_json_file(global_cspell_path) or { words = { '' }, version = '0.2', flagWords = {}, language = 'en' }

  if not vim.tbl_contains(cspell_config.words, word) then
    table.insert(cspell_config.words, word)
  end

  write_json_file(global_cspell_path, cspell_config)
  print('Added word to global cspell.json: ' .. word)
end

M.cspell_code_action = helpers.make_builtin {
  name = 'cspell_code_action',
  method = null_ls.methods.CODE_ACTION,
  filetypes = {}, -- Adjust to your needs
  generator = {
    fn = function(params)
      if not params.diagnostics or vim.tbl_isempty(params.diagnostics) then
        return
      end

      local actions = {}
      for _, diagnostic in ipairs(params.diagnostics) do
        table.insert(actions, {
          title = "Add '" .. diagnostic.message .. "' to global cspell.json",
          action = function()
            M.add_word_to_global_cspell(diagnostic.message)
          end,
        })
      end
      return actions
    end,
  },
}

return M
