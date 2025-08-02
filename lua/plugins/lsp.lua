return {
  -- NOTE: shout-out to TJ, the GOAT
  -- https://github.com/nvim-lua/kickstart.nvim
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },

  {
    'mason-org/mason.nvim',
    config = function()
      require('mason').setup({
        ui = {
          border = 'rounded',
        },
      })
      require('lspconfig.ui.windows').default_options.border = 'rounded'
      vim.diagnostic.config({
        float = {
          border = 'rounded',
        },
      })
    end,
  },

  {
    'mason-org/mason-lspconfig.nvim',
    dependencies = {
      'neovim/nvim-lspconfig',
      'mason-org/mason.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      'saghen/blink.cmp',

      {
        'j-hui/fidget.nvim',
        opts = {},
      },
    },

    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
          map('gt', require('telescope.builtin').lsp_type_definitions, '[G]oto [T]ype Definition')
          map('gi', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
          map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
          map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
          map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
          map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
          map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
          map('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')
          map('K', vim.lsp.buf.hover, 'Hover Documentation')
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
        end,
      })

      -- Diagnostic Config
      -- See :help vim.diagnostic.Opts
      vim.diagnostic.config({
        severity_sort = true,
        float = { border = 'rounded', source = 'if_many' },
        underline = { severity = vim.diagnostic.severity.ERROR },
        signs = vim.g.have_nerd_font and {
          text = {
            [vim.diagnostic.severity.ERROR] = '󰅚 ',
            [vim.diagnostic.severity.WARN] = '󰀪 ',
            [vim.diagnostic.severity.INFO] = '󰋽 ',
            [vim.diagnostic.severity.HINT] = '󰌶 ',
          },
        } or {},
        virtual_text = {
          source = 'if_many',
          spacing = 2,
          format = function(diagnostic)
            local diagnostic_message = {
              [vim.diagnostic.severity.ERROR] = diagnostic.message,
              [vim.diagnostic.severity.WARN] = diagnostic.message,
              [vim.diagnostic.severity.INFO] = diagnostic.message,
              [vim.diagnostic.severity.HINT] = diagnostic.message,
            }
            return diagnostic_message[diagnostic.severity]
          end,
        },
      })

      local servers = {
        eslint = {
          settings = {
            workingDirectory = { mode = 'auto' },
          },
          on_attach = function(_, buffer_number)
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
                library = vim.list_extend(vim.api.nvim_get_runtime_file('lua', true), {
                  '${3rd}/luv/library',
                  '${3rd}/busted/library',
                  '${3rd}/luassert/library',
                }),
              },
              completion = {
                callSnippet = 'Replace',
              },
              telemetry = { enabled = false },
            },
          },
        },
        stylua = {},
        ts_ls = {
          settings = {
            experimental = {
              enableProjectDiagnostics = true,
            },
          },
        },
        gopls = {},
        golangci_lint_ls = {
          -- NOTE: while waiting for https://github.com/nametake/golangci-lint-langserver/issues/51
          init_options = {
            command = {
              'golangci-lint',
              'run',
              '--output.json.path',
              'stdout',
              '--show-stats=false',
              '--issues-exit-code=1',
            },
          },
        },
        html = {},
        templ = {},
        rust_analyzer = {},
        nil_ls = {},
        terraformls = {},
        tflint = {},
        phpactor = {},
        astro = {},
        tsp_server = {},
      }

      -- NOTE: for installing non-LSP tools such as `stylua` etc.
      local ensure_installed = vim.tbl_keys(servers or {})
      require('mason-tool-installer').setup({ ensure_installed = ensure_installed })

      require('mason-lspconfig').setup({
        ensure_installed = {},
        automatic_enable = true,
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            require('lspconfig')[server_name].setup(server)
          end,
        },
      })
    end,
  },
}
