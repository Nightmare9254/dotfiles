local M = {}

M.find_config = function(bufnr, config_files)
  return vim.fs.find(config_files, {
    upward = true,
    stop = vim.fs.dirname(vim.api.nvim_buf_get_name(bufnr)),
    path = vim.fs.dirname(vim.api.nvim_buf_get_name(bufnr)),
  })[1]
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
    -- Run Biome
    local result = vim.fn.system('biome check --write ' .. vim.fn.shellescape(file))
    if vim.v.shell_error == 0 then
      vim.cmd 'edit!'
    else
      vim.api.nvim_err_writeln('Biome error: ' .. result)
    end
  end
  -- Add Prettier logic here if needed
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
