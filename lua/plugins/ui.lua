return {
  {
    'goolord/alpha-nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('alpha').setup(require('alpha.themes.theta').config)
    end,
  },

  {
    'sphamba/smear-cursor.nvim',
    opts = {
      legacy_computing_symbols_support = true,
      transparent_bg_fallback_color = '#303030',
    },
  },

  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
      sections = {
        lualine_x = {
          {
            require('noice').api.status.mode.get,
            cond = require('noice').api.status.mode.has,
            color = { fg = '#ff9e64' },
          },
        },
      },
    },
  },

  {
    'lukas-reineke/indent-blankline.nvim',
    event = 'BufEnter',
    main = 'ibl',
    opts = {
      scope = { enabled = false },
      exclude = {
        filetypes = {
          'help',
          'alpha',
          'dashboard',
          'neo-tree',
          'Trouble',
          'trouble',
          'lazy',
          'mason',
          'notify',
          'toggleterm',
          'lazyterm',
        },
      },
    },
  },
}
