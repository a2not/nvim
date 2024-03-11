return {
  {
    'numToStr/Comment.nvim',
    event = 'VeryLazy',
    dependencies = {
      {
        'JoosepAlviste/nvim-ts-context-commentstring',
        lazy = true,
        opts = {
          enable_autocmd = false,
        },
      },
    },
    config = true,
  },

  {
    'norcalli/nvim-colorizer.lua',
    opts = {
      '*',
    },
  }, -- :ColorizerToggle to see #ffffff
}
