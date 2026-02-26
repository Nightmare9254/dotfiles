local M = {}

-- Utility function to check if files exist in the current working directory
M.files_exist_in_dir = function(filenames)
  local cwd = vim.fn.getcwd()
  for _, filename in ipairs(filenames) do
    if vim.loop.fs_stat(cwd .. '/' .. filename) then
      return true
    end
  end
  return false
end

M.find_config = function(bufnr, config_files)
  return vim.fs.find(config_files, {
    upward = true,
    stop = vim.fs.dirname(vim.api.nvim_buf_get_name(bufnr)),
    path = vim.fs.dirname(vim.api.nvim_buf_get_name(bufnr)),
  })[1]
end

-- Find biome executable, preferring project-local installation
M.find_biome_cmd = function()
  local cwd = vim.fn.getcwd()
  local local_biome = cwd .. '/node_modules/.bin/biome'
  
  -- Check if local biome exists and is executable
  if vim.fn.executable(local_biome) == 1 then
    return local_biome
  end
  
  -- Fall back to global biome
  return 'biome'
end

-- Check if biome config exists
M.has_biome_config = function()
  return M.files_exist_in_dir { 'biome.json', 'biome.jsonc' }
end

-- Check if eslint config exists
M.has_eslint_config = function()
  return M.files_exist_in_dir {
    '.eslintrc',
    '.eslintrc.json',
    '.eslintrc.js',
    '.eslintrc.cjs',
    '.eslintrc.yaml',
    '.eslintrc.yml',
    '.eslintrc.json5',
    'eslint.config.js',
    'eslint.config.cjs',
    'eslint.config.mjs',
  }
end

M.biome_or_prettier = function(bufnr)
  local has_biome_config = M.find_config(bufnr, { 'biome.json', 'biome.jsonc' })

  if has_biome_config then
    return { 'biome', stop_after_first = true }
  end

  local has_prettier_config = M.find_config(bufnr, {
    '.prettierrc',
    '.prettierrc.json',
    '.prettierrc.yml',
    '.prettierrc.yaml',
    '.prettierrc.json5',
    '.prettierrc.js',
    '.prettierrc.cjs',
    '.prettierrc.toml',
    'prettier.config.js',
    'prettier.config.cjs',
  })

  if has_prettier_config then
    return { 'prettier', stop_after_first = true }
  end

  -- Default to Prettier if no config is found
  return { 'prettier', stop_after_first = true }
end

M.format_file = function(bufnr)
  local file = vim.api.nvim_buf_get_name(bufnr)
  local formatter = M.biome_or_prettier(bufnr)

  if formatter[1] == 'biome' then
    local biome_cmd = M.find_biome_cmd()
    local result = vim.fn.system(biome_cmd .. ' check --write ' .. vim.fn.shellescape(file))
    if vim.v.shell_error == 0 then
      vim.cmd 'edit!'
    else
      vim.api.nvim_err_writeln('Biome error: ' .. result)
    end
  elseif formatter[1] == 'prettier' then
    local result = vim.fn.system('prettier --write ' .. vim.fn.shellescape(file))
    if vim.v.shell_error == 0 then
      vim.cmd 'edit!'
    else
      vim.api.nvim_err_writeln('Prettier error: ' .. result)
    end
  end
end

M.filetypes_with_dynamic_formatter = {
  'javascript',
  'javascriptreact',
  'typescript',
  'typescriptreact',
  'vue',
  'css',
  'scss',
  'less',
  'html',
  'json',
  'jsonc',
  'yaml',
  'markdown',
  'markdown.mdx',
  'graphql',
  'handlebars',
}

return M
