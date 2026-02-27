return {
  'neovim/nvim-lspconfig',
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = {
    'hrsh7th/cmp-nvim-lsp',
    { 'antosha417/nvim-lsp-file-operations', config = true },
    { 'folke/neodev.nvim',                   opts = {} },
  },
  config = function()
    local lspconfig = require 'lspconfig'
    local lsp_configurations = require 'lspconfig.configs'
    local cmp_nvim_lsp = require 'cmp_nvim_lsp'
    local util = require 'lspconfig/util'
    local format_utils = require 'format'

    local keymap = vim.keymap -- for conciseness

    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('UserLspConfig', { clear = true }),
      callback = function(ev)
        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local opts = { buffer = ev.buf, silent = true }

        -- set keybinds
        opts.desc = 'Show LSP references'
        keymap.set('n', 'gR', '<cmd>Telescope lsp_references<CR>', opts) -- show definition, references

        opts.desc = 'Go to declaration'
        keymap.set('n', 'gD', vim.lsp.buf.declaration, opts) -- go to declaration

        opts.desc = 'Show LSP definitions'
        keymap.set('n', 'gd', '<cmd>Telescope lsp_definitions<CR>', opts) -- show lsp definitions

        opts.desc = 'Show LSP implementations'
        keymap.set('n', 'gi', '<cmd>Telescope lsp_implementations<CR>', opts) -- show lsp implementations

        opts.desc = 'Show LSP type definitions'
        keymap.set('n', 'gt', '<cmd>Telescope lsp_type_definitions<CR>', opts) -- show lsp type definitions

        opts.desc = 'See available code actions'
        keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

        opts.desc = 'Smart rename'
        keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts) -- smart rename

        opts.desc = 'Show buffer diagnostics'
        keymap.set('n', '<leader>D', '<cmd>Telescope diagnostics bufnr=0<CR>', opts) -- show  diagnostics for file

        opts.desc = 'Show line diagnostics'
        keymap.set('n', '<leader>d', vim.diagnostic.open_float, opts) -- show diagnostics for line

        opts.desc = 'Go to previous diagnostic'
        keymap.set('n', '[d', vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer

        opts.desc = 'Go to next diagnostic'
        keymap.set('n', ']d', vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer

        opts.desc = 'Show documentation for what is under cursor'
        keymap.set('n', 'K', vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

        opts.desc = 'Restart LSP'
        keymap.set('n', '<leader>rs', ':LspRestart<CR>', opts) -- mapping to restart lsp if necessary
      end,
    })

    -- used to enable autocompletion (assign to every lsp server config)
    local capabilities = cmp_nvim_lsp.default_capabilities()

    local lsp_opts = {
      on_init = function(client)
        client.offset_encoding = 'utf-16'
      end,
    }

    -- cspell_lsp (custom server)
    local cspell_cmd
    if vim.fn.executable('cspell-lsp') == 1 then
      cspell_cmd = { 'cspell-lsp', '--stdio' }
    elseif vim.fn.executable('pnpm') == 1 then
      cspell_cmd = { 'pnpm', 'exec', 'cspell-lsp', '--stdio' }
    end

    if cspell_cmd then
      if not lsp_configurations.cspell_lsp then
        lsp_configurations.cspell_lsp = {
          default_config = {
            cmd = cspell_cmd,
            filetypes = {
              'go', 'rust', 'javascript', 'typescript', 'javascriptreact', 'typescriptreact', 'vue',
              'html', 'css', 'json', 'yaml', 'markdown', 'gitcommit',
            },
            root_dir = require('lspconfig.util').root_pattern('.git', 'cspell.json', '.cspell.json'),
          },
        }
      end

      lspconfig.cspell_lsp.setup {
        capabilities = capabilities,
        on_init = lsp_opts.on_init,
      }
    else
      vim.notify('cspell-lsp (or pnpm exec cspell-lsp) not found; cspell LSP disabled', vim.log.levels.WARN)
    end

    -- Change the Diagnostic symbols in the sign column (gutter)
    local signs = { Error = ' ', Warn = ' ', Hint = '󰠠 ', Info = ' ' }
    vim.diagnostic.config {
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = signs.Error,
          [vim.diagnostic.severity.WARN] = signs.Warn,
          [vim.diagnostic.severity.HINT] = signs.Hint,
          [vim.diagnostic.severity.INFO] = signs.Info,
        },
      },
    }



    -- Default LSP servers with basic capabilities
    local default_servers = {
      'ts_ls',
      'html',
      'cssls',
      'tailwindcss',
      'emmet_ls',
      'prismals',
    }

    for _, server_name in ipairs(default_servers) do
      vim.lsp.config(server_name, {
        capabilities = capabilities,
        on_init = lsp_opts.on_init,
      })
      vim.lsp.enable(server_name)
    end

    -- eslint (only if project has eslint config)
    if format_utils.has_eslint_config() then
      vim.lsp.config('eslint', {
        capabilities = capabilities,
        on_init = lsp_opts.on_init,
        settings = {
          autoFixOnSave = true,
        },
      })
      vim.lsp.enable('eslint')
    end

    -- gopls
    vim.lsp.config('gopls', {
      capabilities = capabilities,
      on_init = lsp_opts.on_init,
      cmd = { 'gopls' },
      filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
      root_dir = util.root_pattern('go.work', 'go.mod', '.git'),
      settings = {
        gopls = {
          gofumpt = true,
          codelenses = {
            gc_details = false,
            generate = true,
            regenerate_cgo = true,
            run_govulncheck = true,
            test = true,
            tidy = true,
            upgrade_dependency = true,
            vendor = true,
          },
          hints = {
            assignVariableTypes = true,
            compositeLiteralFields = true,
            compositeLiteralTypes = true,
            constantValues = true,
            functionTypeParameters = true,
            parameterNames = true,
            rangeVariableTypes = true,
          },
          analyses = {
            nilness = true,
            unusedparams = true,
            unusedwrite = true,
            useany = true,
          },
          usePlaceholders = true,
          completeUnimported = true,
          staticcheck = true,
          directoryFilters = { '-.git', '-.vscode', '-.idea', '-.vscode-test', '-node_modules' },
          semanticTokens = true,
        },
      },
    })
    vim.lsp.enable('gopls')

    -- biome (if biome config exists and eslint is not configured)
    if format_utils.has_biome_config() and not format_utils.has_eslint_config() then
      vim.lsp.config('biome', {
        cmd = { format_utils.find_biome_cmd(), 'lsp-proxy' },
        capabilities = capabilities,
        on_init = lsp_opts.on_init,
        filetypes = { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' },
      })
      vim.lsp.enable('biome')
    end

    -- lua_ls
    vim.lsp.config('lua_ls', {
      capabilities = capabilities,
      on_init = lsp_opts.on_init,
      settings = {
        Lua = {
          diagnostics = {
            globals = { 'vim' },
            disabled = { 'missing-fields' },
          },
          completion = {
            callSnippet = 'Replace',
          },
        },
      },
    })
    vim.lsp.enable('lua_ls')

    -- volar
    vim.lsp.config('volar', {
      capabilities = capabilities,
      on_init = lsp_opts.on_init,
      filetypes = { 'vue', 'javascript', 'typescript', 'javascriptreact', 'typescriptreact' },
      root_dir = util.root_pattern('package.json', 'nuxt.config.ts', 'nuxt.config.js', '.git'),
      init_options = {
        vue = {
          hybridMode = false,
        },
      },
    })
    vim.lsp.enable('volar')
  end,
}
