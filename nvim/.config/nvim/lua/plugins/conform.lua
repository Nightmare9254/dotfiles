local format_utils = require 'format'

return {
  'stevearc/conform.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    require('conform').setup {
      -- formatters_by_ft = {
      lua = { 'stylua' },
      go = { { "gofmt", "goimports", 'goimports_reviser' } },
      --   svelte = { 'prettierd' },
      --   ['javascript'] = { 'biome-check' },
      --   ['typescript'] = { 'biome-check' },
      --   ['javascriptreact'] = { 'biome-check' },
      --   ['typescriptreact'] = { 'biome-check' },
      --   ['json'] = { 'biome-check' },
      --   graphql = { 'prettierd' },
      --   java = { 'google-java-format' },
      --   kotlin = { 'ktlint' },
      --   ruby = { 'standardrb' },
      --   markdown = { 'prettierd' },
      --   erb = { 'htmlbeautifier' },
      --   html = { 'htmlbeautifier' },
      --   bash = { 'beautysh' },
      --   proto = { 'buf' },
      --   rust = { 'rustfmt' },
      --   yaml = { 'yamlfix' },
      --   toml = { 'taplo' },
      --   ['css'] = { 'biome-check' },
      --   ['scss'] = { 'biome-check' },
      -- },
      formatters_by_ft = (function()
        local result = {}
        print "test"
        for _, ft in ipairs(format_utils.filetypes_with_dynamic_formatter) do
          result[ft] = format_utils.biome_or_prettier
        end
        return result
      end)(),

      format_on_save = function(bufnr)
        local disable_filetypes = {
          c = true,
          cpp = true,
        }

        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end

        return { timeout_ms = 500, lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype], async = false }
      end,
      formatters = {
        biome = {
          command = 'biome',
          args = { 'check', '--write', '$FILENAME' },
          stdin = false,
        },
      },
    }
    local conform = require 'conform'
    vim.keymap.set({ 'n', 'v' }, '<leader>l', function()
      conform.format {
        lsp_fallback = true,
        async = false,
        timeout_ms = 500,
      }
    end, { desc = 'Format file or range (in visual mode)' })
  end,
}
