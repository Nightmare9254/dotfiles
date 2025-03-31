local format_utils = require 'format'

return {
  'stevearc/conform.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    require('conform').setup {
      -- formatters_by_ft = {
      lua = { 'stylua' },
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
        for _, ft in ipairs(format_utils.filetypes_with_dynamic_formatter) do
          result[ft] = format_utils.biome_or_prettier
        end
        return result
      end)(),

      format_on_save = function(bufnr)
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local disable_filetypes = {
          c = true,
          cpp = true,
        }
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end
        local formatter = format_utils.biome_or_prettier(bufnr)
        if formatter[1] == 'biome' then
          return { timeout_ms = 500, lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype], async = false }
        elseif formatter[1] == 'prettier' then
          return { timeout_ms = 500, lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype], async = false }
        end
        return nil
      end,
      formatters = {
        biome = {
          command = 'biome',
          args = { 'check', '--write', '$FILENAME' }, --  ← this was the magic that fixed organizing imports
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
