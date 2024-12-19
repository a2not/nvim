return {
  {
    'hrsh7th/nvim-cmp',
    event = { 'BufReadPost', 'BufNewFile', 'InsertEnter', 'CmdlineEnter' },
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'ray-x/cmp-treesitter',
      'hrsh7th/cmp-cmdline',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-nvim-lsp-document-symbol',
      'hrsh7th/cmp-nvim-lua',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-emoji',

      'onsails/lspkind.nvim',

      {
        'L3MON4D3/LuaSnip',
        version = 'v2.*',
      },
      'saadparwaiz1/cmp_luasnip',

      'lukas-reineke/cmp-rg',

      'windwp/nvim-ts-autotag',
      'windwp/nvim-autopairs',
    },
    config = function()
      vim.api.nvim_set_hl(0, 'CmpGhostText', { link = 'Comment', default = true })

      local cmp = require('cmp')
      local lspkind = require('lspkind')
      local luasnip = require('luasnip')
      local cmp_autopairs = require('nvim-autopairs.completion.cmp')

      require('nvim-autopairs').setup()
      -- Integrate nvim-autopairs with cmp
      cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())

      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
      end

      local superTab = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        elseif has_words_before() then
          cmp.complete()
        else
          fallback()
        end
      end, { 'i', 's' })

      local shiftSuperTab = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, { 'i', 's' })

      cmp.setup({
        completion = {
          completeopt = 'menu,menuone,noinsert,noselect',
        },
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        preselect = cmp.PreselectMode.None,
        mapping = cmp.mapping.preset.insert({
          ['<C-d>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.close(),
          -- https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings#safely-select-entries-with-cr
          ['<CR>'] = cmp.mapping({
            i = function(fallback)
              if cmp.visible() and cmp.get_active_entry() then
                cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
              else
                fallback()
              end
            end,
            s = cmp.mapping.confirm({ select = true }),
            c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false }),
          }),

          -- Super-Tab like mapping from nvim-cmp wiki
          -- https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings#luasnip
          ['<Tab>'] = superTab,
          ['<Down>'] = superTab,
          ['<S-Tab>'] = shiftSuperTab,
          ['<Up>'] = shiftSuperTab,
        }),
        sources = cmp.config.sources({
          { name = 'path' },
          { name = 'emoji' },
          { name = 'treesitter' },
          { name = 'nvim_lsp' },
          { name = 'nvim_lua' },
          { name = 'nvim_lsp_signature_help' },
          { name = 'luasnip', option = { show_autosnippets = true } },
          {
            name = 'rg',
            keyword_length = 3,
          },
        }),
        formatting = {
          expandable_indicator = true,
          format = lspkind.cmp_format({
            mode = 'symbol_text',
            maxwidth = 50,
            ellipsis_char = '...',
          }),
        },
        experimental = {
          ghost_text = {
            hl_group = 'CmpGhostText',
          },
        },
      })

      -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline({ '/', '?' }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = 'nvim_lsp_document_symbol' },
          { name = 'buffer' },
        }),
      })

      -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = 'path' },
          { name = 'cmdline' },
        }),
      })
    end,
  },
}
