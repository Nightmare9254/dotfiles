return {
  'williamboman/mason.nvim',
  dependencies = {
    'williamboman/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',
  },
  config = function()
    -- import mason
    local mason = require 'mason'

    -- import mason-lspconfig
    local mason_lspconfig = require 'mason-lspconfig'

    local mason_tool_installer = require 'mason-tool-installer'

    -- enable mason and configure icons
    mason.setup {
      ui = {
        icons = {
          package_installed = '✓',
          package_pending = '➜',
          package_uninstalled = '✗',
        },
      },
    }

    mason_lspconfig.setup {
      -- list of servers for mason to install
      ensure_installed = {
        'tsserver',
        'html',
        'cssls',
        'volar',
        'tailwindcss',
        'lua_ls',
        'graphql',
        'emmet_ls',
        'prismals',
        'eslint',
        'golangci_lint_ls',
        'pylsp',
      },
    }

    mason_tool_installer.setup {
      ensure_installed = {
        'prettierd', -- prettier formatter
        'eslint_d',
        'stylua', -- lua formatter
        'black', -- python formatter
        'mypy',
        'pylint',
        'flake8',
        'debugpy',
        'cspell',
        'misspell',
        'codespell',
      },
    }
  end,
}
