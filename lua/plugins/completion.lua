return {
  {
    'saghen/blink.cmp',
    event = 'VimEnter',
    version = '1.*',
    dependencies = {
      {
        'L3MON4D3/LuaSnip',
        version = '2.*',
        build = 'make install_jsregexp',
        dependencies = {
          {
            'rafamadriz/friendly-snippets',
            config = function()
              require('luasnip.loaders.from_vscode').lazy_load()
            end,
          },
        },
        opts = {},
      },
      'folke/lazydev.nvim',
      'fang2hou/blink-copilot',
    },

    --- @module 'blink.cmp'
    --- @type blink.cmp.Config
    opts = {
      keymap = {
        preset = 'enter',
        ['<C-y>'] = { 'select_and_accept' },
        ['<Tab>'] = { 'select_next', 'snippet_forward', 'fallback' },
        ['<S-Tab>'] = { 'select_prev', 'snippet_backward', 'fallback' },
      },

      appearance = {
        nerd_font_variant = 'mono',
      },

      completion = {
        accept = {
          auto_brackets = {
            enabled = false,
          },
        },
        menu = {
          border = 'rounded',
          draw = {
            treesitter = { 'lsp' },
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 500,
          window = {
            border = 'rounded',
          },
        },
        ghost_text = {
          enabled = vim.g.ai_cmp,
        },
      },

      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer', 'lazydev', 'copilot' },
        providers = {
          lazydev = {
            name = 'lazydev',
            module = 'lazydev.integrations.blink',
            score_offset = 100,
          },
          copilot = {
            name = 'copilot',
            module = 'blink-copilot',
            score_offset = 100,
            async = true,
          },
        },
      },

      snippets = { preset = 'luasnip' },

      fuzzy = { implementation = 'prefer_rust_with_warning' },
    },

    opts_extend = { 'sources.default' },
  },
}
