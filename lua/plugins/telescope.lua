return {
  'nvim-telescope/telescope.nvim',
  event = 'VeryLazy',
  dependencies = {
    {
      'nvim-lua/plenary.nvim',
    },
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
      enabled = vim.fn.executable('make') == 1,
      config = function()
        require('telescope').load_extension('fzf')
      end,
    },
    {
      'rcarriga/nvim-notify',
      config = function()
        require('telescope').load_extension('notify')
      end,
    },
  },
  keys = {
    -- Using Lua functions
    -- -- <C-v> Go to file selection as a vsplit
    {
      '<leader>ff',
      function()
        require('telescope.builtin').find_files({ hidden = true })
      end,
      mode = 'n',
      desc = 'find files',
    },
    {
      '<leader>fg',
      function()
        require('telescope.builtin').live_grep()
      end,
      mode = 'n',
      desc = 'live grep',
    },
    {
      '<leader>fb',
      function()
        require('telescope.builtin').buffers()
      end,
      mode = 'n',
      desc = 'find buffers',
    },
    {
      '<leader>gf',
      function()
        require('telescope.builtin').git_status()
      end,
      mode = 'n',
      desc = 'git files',
    },
    {
      '<leader>/',
      function()
        require('telescope.builtin').current_buffer_fuzzy_find()
      end,
      mode = 'n',
      desc = 'current buffer fuzzy find',
    },
    {
      '<leader>fw',
      function()
        require('telescope.builtin').grep_string()
      end,
      mode = 'n',
      desc = 'search word under cursor',
    },
    {
      '<leader>fh',
      function()
        require('telescope.builtin').help_tags()
      end,
      mode = 'n',
      desc = 'find help',
    },
    {
      '<leader>fk',
      function()
        require('telescope.builtin').keymaps()
      end,
      mode = 'n',
      desc = 'find keymaps',
    },
    {
      '<leader>fr',
      function()
        require('telescope.builtin').resume()
      end,
      mode = 'n',
      desc = 'find resume',
    },
    {
      '<leader>fe',
      function()
        require('telescope.builtin').diagnostics({ bufnr = 0 })
      end,
      mode = 'n',
      desc = 'diagnostics',
    },
    {
      '<leader>fn',
      function()
        require('telescope').extensions.notify.notify({})
      end,
      mode = 'n',
      desc = 'View Notification History',
    },
  },
  opts = function()
    return {
      defaults = {
        layout_config = {
          width = 0.95,
          horizontal = {
            preview_width = function(_, cols, _)
              return math.floor(cols * 0.6)
            end,
          },
        },
        -- path_display = {
        --   truncate = 4,
        --   shorten = 4,
        -- },
        vimgrep_arguments = {
          'rg',
          '--color=never',
          '--no-heading',
          '--with-filename',
          '--line-number',
          '--column',
          '--smart-case',
          -- NOTE: default above, see :h telescope.defaults.vimgrep_arguments
          -- below is the additional, in order to apply live_grep and grep_string at the same time.
          '--hidden',
          '--glob',
          '!{**/.git/*,**/node_modules/*}',
        },
      },
    }
  end,
}
