return {
  'nvimtools/none-ls.nvim',
  keys = {
    { '<leader>cn', '<cmd>NullLsInfo<cr>', desc = '[C]spell [N]ullLs Info' },
  },
  dependencies = { 'mason.nvim', 'davidmh/cspell.nvim' },
  event = { 'BufReadPre', 'BufNewFile' },
  ft = { 'typescriptreact', 'javascriptreact', 'html', 'javascript', 'typescript', 'vue', 'markdown', 'python' },
  opts = function()
    local cspell = require 'cspell'
    local null_ls = require 'null-ls'
    local helpers = require 'null-ls.helpers'

    local function should_disable(filename)
      local disable_filetypes = { 'lua' }
      local filetype = vim.bo.filetype
      if vim.tbl_contains(disable_filetypes, filetype) then
        return false
      end

      local disable_filenames = {}
      if vim.tbl_contains(disable_filenames, vim.fn.fnamemodify(filename, ':t')) then
        return false
      end

      return true
    end

    local function add_word_to_cspell(word, cspell_path)
      local cspell_config
      if vim.fn.filereadable(cspell_path) == 1 then
        cspell_config = vim.fn.json_decode(table.concat(vim.fn.readfile(cspell_path), '\n'))
      else
        cspell_config = { words = { '' }, version = '0.2', flagWords = {}, language = 'en' }
      end

      if not vim.tbl_contains(cspell_config.words, word) then
        table.insert(cspell_config.words, word)
        vim.fn.writefile({ vim.fn.json_encode(cspell_config) }, cspell_path)
      end
    end

    local add_word_action = helpers.make_builtin {
      method = null_ls.methods.CODE_ACTION,
      filetypes = { 'typescriptreact', 'javascriptreact', 'html', 'javascript', 'typescript', 'vue', 'markdown', 'python' },
      generator = {
        fn = function(params)
          local row = params.row
          local line = params.content[row]
          local col = params.col

          -- Determine word boundaries using regular expressions for common coding conventions
          local start_col, end_col = col, col
          while start_col > 0 and line:sub(start_col, start_col):match '[%w_]' do
            start_col = start_col - 1
          end
          start_col = start_col + 1
          while end_col <= #line and line:sub(end_col, end_col):match '[%w_]' do
            end_col = end_col + 1
          end
          end_col = end_col - 1

          -- Extract the word under the cursor
          local word = line:sub(start_col, end_col)

          -- If word is in camelCase or snake_case, extract individual words
          local words = {}
          for w in word:gmatch '[A-Z]?[a-z0-9_]+' do
            table.insert(words, w)
          end
          word = words[#words] -- Select the last word for camelCase or snake_case

          return {
            {
              title = string.format('Add "%s" to global cspell.json', word),
              action = function()
                local global_cspell_path = vim.fn.expand '~/.config/nvim/cspell.json'
                add_word_to_cspell(word, global_cspell_path)
              end,
            },
            -- {
            --   title = string.format('Add "%s" to local cspell.json', word),
            --   action = function()
            --     local local_cspell_path = params.root and params.root .. '/.cspell.json' or nil
            --     if local_cspell_path then
            --       add_word_to_cspell(word, local_cspell_path)
            --     else
            --       -- If no root path is available, create a .cspell.json file in the current directory
            --       local current_dir_cspell_path = vim.fn.getcwd() .. '/.cspell.json'
            --       add_word_to_cspell(word, current_dir_cspell_path)
            --     end
            --   end,
            -- },
          }
        end,
      },
    }

    local sources = {
      cspell.diagnostics.with {
        diagnostics_postprocess = function(diagnostic)
          diagnostic.severity = vim.diagnostic.severity.HINT
        end,
        condition = function(utils)
          return should_disable(utils.root_has_file '.cspell.json')
        end,
      },
      cspell.code_actions.with {
        condition = function(utils)
          return should_disable(utils.root_has_file '.cspell.json')
        end,
      },
      add_word_action,
    }

    local debounce_value = 200
    return {
      sources = sources,
      debounce = debounce_value,
      debug = true,
    }
  end,
}
