return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  keys = {
    {
      '<leader>fm',
      function()
        require('conform').format({ async = true, lsp_fallback = true })
      end,
      mode = 'n',
      desc = 'Conform: format (async)',
    },
  },
  opts = {
    notify_on_error = false,
    -- format_on_save = {
    --   timeout_ms = 500,
    --   lsp_fallback = true,
    -- },
    formatters_by_ft = {
      lua = { 'stylua' },
      go = { 'gofmt', 'goimports' },
      nix = { 'alejandra' },
      -- javascript = { 'eslint', { 'prettierd', 'prettier' } },
      -- typescript = { 'eslint', { 'prettierd', 'prettier' } },
      -- javascriptreact = { 'eslint', { 'prettierd', 'prettier' } },
      -- typescriptreact = { 'eslint', { 'prettierd', 'prettier' } },
    },
  },
}
