return {
  'nvim-neo-tree/neo-tree.nvim',
  branch = 'v3.x',
  cmd = 'Neotree',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
    -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
  },
  keys = {
    {
      '<leader>e',
      function()
        require('neo-tree.command').execute({ toggle = true, dir = vim.loop.cwd() })
      end,
      desc = 'Explorer NeoTree (cwd)',
    },
    {
      '<leader>ge',
      function()
        require('neo-tree.command').execute({ toggle = true, source = 'git_status' })
      end,
      desc = 'Git explorer',
    },
    {
      '<leader>be',
      function()
        require('neo-tree.command').execute({ toggle = true, source = 'buffers' })
      end,
      desc = 'Buffer explorer',
    },
  },
  opts = {
    filesystem = {
      filtered_items = {
        visible = true,
        hide_dotfiles = false,
        hide_gitignored = false,
        hide_hidden = false,
      },
      follow_current_file = {
        enabled = true,
        leave_dirs_open = true,
      },
      window = {
        mappings = {
          ['[c'] = 'prev_git_modified',
          [']c'] = 'next_git_modified',
        },
      },
    },
    event_handlers = {
      {
        event = 'file_opened',
        handler = function(file_path)
          require('neo-tree.command').execute({ action = 'close' })
        end,
      },
    },
  },
}
