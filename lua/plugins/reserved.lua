return {
  --  vim.g.undotree_SetFocusWhenToggle = true
  --  {
  --    'mbbill/undotree',
  --    keys = {
  --      { '<leader>ut', [[<Cmd>UndotreeToggle<CR>]], mode = 'n', desc = 'Undotree toggle' },
  --    },
  --  },

  -- {
  --   'marilari88/twoslash-queries.nvim',
  --   opts = {
  --     multi_line = true,
  --   },
  -- },

  --  {
  --    'nvim-tree/nvim-tree.lua',
  --    dependencies = {
  --      'nvim-tree/nvim-web-devicons',
  --    },
  --    version = 'nightly', -- optional, updated every week. (see issue #1193)
  --    opts = {
  --      update_focused_file = {
  --        enable = true,
  --      },
  --      git = {
  --        ignore = false,
  --      },
  --    },
  --    -- --- https://github.com/nvim-tree/nvim-tree.lua/wiki/Open-At-Startup
  --    -- local function open_nvim_tree(data)
  --    --   -- buffer is a real file on the disk
  --    --   local real_file = vim.fn.filereadable(data.file) == 1
  --    --   -- buffer is a directory
  --    --   local directory = vim.fn.isdirectory(data.file) == 1
  --    --    -- buffer is a [No Name]
  --    --   local no_name = data.file == '' and vim.bo[data.buf].buftype == ''

  --    --    -- `cd` if buffer is a directory
  --    --   if directory then
  --    --     vim.cmd.cd(data.file)
  --    --   end

  --    --   -- focus tree when `vim` (without any arguments)
  --    --   if not real_file and not directory and no_name then
  --    --     require('nvim-tree.api').tree.toggle()
  --    --     return
  --    --   end

  --    --   -- open the tree, find the file but don't focus it
  --    --   require('nvim-tree.api').tree.toggle({ focus = false, find_file = true, })
  --    -- end

  --    -- vim.api.nvim_create_autocmd({ 'VimEnter' }, { callback = open_nvim_tree })
  --  },
}
