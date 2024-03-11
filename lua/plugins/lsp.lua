return {
  -- NOTE: shout-out to Dillon Mulroy for awesome lsp conf
  -- https://github.com/dmmulroy/kickstart.nix/blob/a4a283334890b521b357546770a6b3ce6c18de17/config/nvim/lua/plugins/lsp.lua
  -- NOTE: shout-out to TJ, the GOAT
  -- https://github.com/nvim-lua/kickstart.nvim

  'neovim/nvim-lspconfig',
  dependencies = {
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    'hrsh7th/cmp-nvim-lsp',

    {
      'folke/neodev.nvim',
      opts = {},
    },

    {
      'j-hui/fidget.nvim',
      opts = {},
    },
  },

  config = function()
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
      callback = function(event)
        local map = function(keys, func, desc)
          vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end

        map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
        map('gt', require('telescope.builtin').lsp_type_definitions, '[G]oto [T]ype Definition')
        map('gi', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
        -- NOTE: used to be `require('telescope.builtin').lsp_references({ show_line = false })`
        map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
        map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
        map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
        map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
        map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
        map('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')
        map('K', vim.lsp.buf.hover, 'Hover Documentation')
        map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
        -- NOTE: format command defined in conform.nvim
        -- map('<leader>fm', function()
        --   vim.lsp.buf.format({ async = true })
        -- end, 'Format (async)')
      end,
    })

    local servers = {
      eslint = {
        settings = {
          workingDirectory = { mode = 'auto' },
        },
        on_attach = function(_client, buffer_number)
          -- NOTE: use EslintFixAll as formatter if eslint is attached
          vim.keymap.set(
            'n',
            '<leader>fm',
            [[<Cmd>EslintFixAll<CR>]],
            { desc = 'EslintFixAll', buffer = buffer_number }
          )
          vim.api.nvim_create_autocmd('BufWritePre', {
            buffer = buffer_number,
            command = 'EslintFixAll',
          })
        end,
      },
      jsonls = {},
      lua_ls = {
        settings = {
          Lua = {
            runtime = { version = 'LuaJIT' },
            workspace = {
              checkThirdParty = false,
              library = {
                '${3rd}/luv/library',
                unpack(vim.api.nvim_get_runtime_file('', true)),
              },
            },
            completion = {
              callSnippet = 'Replace',
            },
            telemetry = { enabled = false },
          },
        },
      },
      tsserver = {
        settings = {
          experimental = {
            enableProjectDiagnostics = true,
          },
        },
      },
      gopls = {},
      golangci_lint_ls = {},
      rust_analyzer = {},
      nil_ls = {},
    }

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    local default_capabilities =
      vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

    local default_handlers = {
      ['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'rounded' }),
      ['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = 'rounded' }),
    }

    require('mason').setup({
      ui = {
        border = 'rounded',
      },
    })

    local ensure_installed = vim.tbl_keys(servers or {})
    vim.list_extend(ensure_installed, {
      'stylua',
    })
    require('mason-tool-installer').setup({ ensure_installed = ensure_installed })

    require('mason-lspconfig').setup({
      handlers = {
        function(server_name)
          local server = servers[server_name] or {}
          server.capabilities = vim.tbl_deep_extend('force', {}, default_capabilities, server.capabilities or {})
          server.handlers = vim.tbl_deep_extend('force', {}, default_handlers, server.handlers or {})
          require('lspconfig')[server_name].setup(server)
        end,
      },
    })

    require('lspconfig.ui.windows').default_options.border = 'rounded'
    vim.diagnostic.config({
      float = {
        border = 'rounded',
      },
    })
  end,
}
