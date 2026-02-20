
vim.g.have_nerd_font = true

vim.opt.encoding = 'utf-8'
vim.opt.fileencoding = 'utf-8'

vim.opt.fileformats = { 'unix', 'dos' }

local line_endings_group = vim.api.nvim_create_augroup('UserLineEndings', { clear = true })

vim.api.nvim_create_autocmd('BufReadPost', {
  group = line_endings_group,

  callback = function()
    vim.bo.fileformat = 'unix'
    vim.cmd('silent! %s/\\r$//e')
  end,
})

vim.api.nvim_create_autocmd('BufWritePre', {
  group = line_endings_group,

  callback = function()
    vim.bo.fileformat = 'unix'
    end,
})

vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.mouse = 'a'

vim.opt.showmode = false

vim.opt.clipboard = 'unnamedplus'
vim.opt.breakindent = true

vim.opt.undofile = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.signcolumn = 'yes'

vim.opt.updatetime = 250

vim.opt.timeoutlen = 300

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.backspace = 'indent,eol,start'
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

vim.opt.inccommand = 'split'

vim.opt.cursorline = true

vim.opt.scrolloff = 15
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Disable autosave swapfile
vim.opt.swapfile = false

vim.opt.laststatus = 3

vim.opt.guicursor = {
  'n-v-c:block',                                  -- Normal, visual, command-line: block cursor
  'i-ci-ve:ver25',                                -- Insert, command-line insert, visual-exclude: vertical bar cursor with 25% width
  'r-cr:hor20',                                   -- Replace, command-line replace: horizontal bar cursor with 20% height
  'o:hor50',                                      -- Operator-pending: horizontal bar cursor with 50% height
  'a:blinkwait700-blinkoff400-blinkon250',        -- All modes: blinking settings
  'sm:block-blinkwait175-blinkoff150-blinkon175', -- Showmatch: block cursor with specific blinking settings
}

require 'keymaps'
require 'autocmd'
-- [[ Configure and install plugins ]]
--
--  To check the current status of your plugins, run
--    :Lazy
--
--  You can press `?` in this menu for help. Use `:q` to close the window
--
--  To update plugins you can run
--    :Lazy update
--
-- NOTE: Here is where you install your plugins.
require('lazy').setup({ { import = 'plugins' }, { import = 'plugins.lsp' } }, {
  checker = { enabled = true },
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
