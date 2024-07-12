return {
  'stevearc/conform.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    require('conform').setup {
      formatters_by_ft = {
        lua = { 'stylua' },
        svelte = { { 'prettierd', 'prettier' } },
        javascript = { { 'prettierd', 'prettier' } },
        typescript = { { 'prettierd', 'prettier' } },
        javascriptreact = { { 'prettierd', 'prettier' } },
        typescriptreact = { { 'prettierd', 'prettier' } },
        json = { { 'prettierd', 'prettier' } },
        graphql = { { 'prettierd', 'prettier' } },
        java = { 'google-java-format' },
        kotlin = { 'ktlint' },
        ruby = { 'standardrb' },
        markdown = { { 'prettierd', 'prettier' } },
        erb = { 'htmlbeautifier' },
        html = { 'htmlbeautifier' },
        bash = { 'beautysh' },
        proto = { 'buf' },
        rust = { 'rustfmt' },
        yaml = { 'yamlfix' },
        toml = { 'taplo' },
        css = { { 'prettierd', 'prettier' } },
        scss = { { 'prettierd', 'prettier' } },
      },
      format_on_save = function(bufnr)
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local disable_filetypes = {
          c = true,
          cpp = true,
        }
        return {
          timeout_ms = 499,
          lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
        }
      end,
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
