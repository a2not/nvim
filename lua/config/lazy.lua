local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  spec = 'plugins',
  install = {
    colorscheme = { 'tokyonight' },
  },
  ui = {
    border = 'rounded',
  },
  change_detection = {
    enabled = true, -- automatically check for config file changes and reload the ui. (same as default of true)
    notify = false, -- get a notification when changes are found
  },
})

vim.keymap.set('n', '<leader>l', [[<Cmd>Lazy<CR>]], { desc = 'Open Lazy' })
