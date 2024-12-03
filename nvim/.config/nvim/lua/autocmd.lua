-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- Create the autocommand for saving the current buffer
-- Utility function to check if any file in a list exists in the current working directory
local function files_exists_in_dir(filenames)
  local cwd = vim.fn.getcwd()
  for _, filename in ipairs(filenames) do
    if vim.loop.fs_stat(cwd .. '/' .. filename) then
      return true
    end
  end
  return false
end

-- ESLint Fix on Save: Conditional Setup
local eslint_group = vim.api.nvim_create_augroup('ESLintFixOnSave', { clear = true })
if files_exists_in_dir { '.eslintrc', '.eslintrc.json' } then
  vim.api.nvim_create_autocmd('BufWritePost', {
    group = eslint_group,
    pattern = '*.jsx,*.ts,*.tsx', -- Adjust patterns to match your project files
    callback = function()
      vim.cmd 'EslintFixAll'
    end,
  })
end

-- Biome Format and Lint on Save: Conditional Setup
local biome_group = vim.api.nvim_create_augroup('BiomeFixOnSave', { clear = true })
if files_exists_in_dir { 'biome.json' } then
  vim.api.nvim_create_autocmd('BufWritePost', {
    group = biome_group,
    pattern = '*.tsx,*.ts,*.jsx', -- Adjust patterns to match your project files
    callback = function()
      vim.fn.system 'biome lint --write --unsafe'
      vim.fn.system 'biome format --write --unsafe'
    end,
  })
end

-- avoid the automatic insert mode when a file is opened with telescope
-- https://github.com/nvim-telescope/telescope.nvim/issues/2027#issuecomment-1561836585
vim.api.nvim_create_autocmd('WinLeave', {
  callback = function()
    if vim.bo.ft == 'TelescopePrompt' and vim.fn.mode() == 'i' then
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'i', false)
    end
  end,
})

-- Autoupdate plugins if needed
local function augroup(name)
  return vim.api.nvim_create_augroup('lazyvim_' .. name, { clear = true })
end

vim.api.nvim_create_autocmd('VimEnter', {
  group = augroup 'autoupdate',
  callback = function()
    if require('lazy.status').has_updates then
      require('lazy').update { show = false }
    end
  end,
})
