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
    format_on_save = function(bufnr)
      -- Disable autoformat on certain filetypes
      local ignore_filetypes = { 'javascript', 'typescript', 'javascriptreact', 'typescriptreact' }
      if vim.tbl_contains(ignore_filetypes, vim.bo[bufnr].filetype) then
        return
      end
      -- Disable with a global or buffer-local variable
      if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
        return
      end
      -- Disable autoformat for files in a certain path
      local bufname = vim.api.nvim_buf_get_name(bufnr)
      if bufname:match('/node_modules/') then
        return
      end
      return { timeout_ms = 500, lsp_fallback = true }
    end,
    formatters_by_ft = {
      lua = { 'stylua' },
      go = { 'gofmt', 'goimports' },
      templ = { 'templ' },
      nix = { 'alejandra' },
      sql = { 'sqlfmt' },

      terraform = { 'terraform_fmt' },
      tf = { 'terraform_fmt' },
      ['terraform-vars'] = { 'terraform_fmt' },

      -- javascript = { 'eslint', { 'prettierd', 'prettier' } },
      -- typescript = { 'eslint', { 'prettierd', 'prettier' } },
      -- javascriptreact = { 'eslint', { 'prettierd', 'prettier' } },
      -- typescriptreact = { 'eslint', { 'prettierd', 'prettier' } },
    },
  },
}
