return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  config = function()
    local harpoon = require 'harpoon'

    harpoon:setup()

    vim.keymap.set('n', '<leader>a', function()
      harpoon:list():add()
    end, { desc = '[A]dd to harpoon' })
    vim.keymap.set('n', '<leader>1', function()
      harpoon:list():select(1)
    end, { desc = '[1] first element' })
    vim.keymap.set('n', '<leader>2', function()
      harpoon:list():select(2)
    end, { desc = '[2] first element' })
    vim.keymap.set('n', '<leader>3', function()
      harpoon:list():select(3)
    end, { desc = '[3] first element' })
    vim.keymap.set('n', '<leader>4', function()
      harpoon:list():select(4)
    end, { desc = '[1] first element' })

    -- Toggle previous & next buffers stored within Harpoon list
    vim.keymap.set('n', '<C-S-P>', function()
      harpoon:list():prev()
    end)
    vim.keymap.set('n', '<C-S-N>', function()
      harpoon:list():next()
    end)

    local function toggle_telescope(harpoon_files)
      local finder = function()
        local paths = {}
        for _, item in ipairs(harpoon_files.items) do
          table.insert(paths, item.value)
        end

        return require('telescope.finders').new_table {
          results = paths,
        }
      end

      require('telescope.pickers')
        .new({}, {
          prompt_title = 'Harpoon',
          finder = finder(),
          previewer = false,
          sorter = require('telescope.config').values.generic_sorter {},
          layout_config = {
            height = 0.4,
            width = 0.5,
            prompt_position = 'top',
            preview_cutoff = 120,
          },
          attach_mappings = function(prompt_bufnr, map)
            map('i', '<C-d>', function()
              local state = require 'telescope.actions.state'
              local selected_entry = state.get_selected_entry()
              local current_picker = state.get_current_picker(prompt_bufnr)
              if selected_entry == nil then
                return
              end
              table.remove(harpoon_files.items, selected_entry.index)
              current_picker:refresh(finder())
            end)
            return true
          end,
        })
        :find()
    end
    vim.keymap.set('n', '<C-e>', function()
      toggle_telescope(harpoon:list())
    end, { desc = '[E]xpand harpoon window' })
  end,
}