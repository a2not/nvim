return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  event = { 'BufEnter' },
  init = function(plugin)
    -- PERF: add nvim-treesitter queries to the rtp and it's custom query predicates early
    -- This is needed because a bunch of plugins no longer `require("nvim-treesitter")`, which
    -- no longer trigger the **nvim-treeitter** module to be loaded in time.
    -- Luckily, the only thins that those plugins need are the custom queries, which we make available
    -- during startup.
    require('lazy.core.loader').add_to_rtp(plugin)
    require('nvim-treesitter.query_predicates')
  end,
  dependencies = {
    'nvim-treesitter/nvim-treesitter-context',
    'nvim-treesitter/nvim-treesitter-textobjects',
    {
      'm-demare/hlargs.nvim',
      config = true,
    },
    {
      'andymass/vim-matchup',
    },
    {
      'windwp/nvim-ts-autotag',
    },
    {
      'RRethy/vim-illuminate',
      lazy = true,
      config = function()
        require('illuminate').configure({
          delay = 200,
          large_file_cutoff = 2000,
          large_file_overrides = {
            providers = {
              'lsp',
              'treesitter',
            },
          },
        })
      end,
      keys = {
        {
          '<leader>n',
          function()
            require('illuminate').goto_next_reference()
          end,
          mode = 'n',
          desc = 'illuminate goto_next_reference',
        },
        {
          '<leader>N',
          function()
            require('illuminate').goto_prev_reference()
          end,
          mode = 'n',
          desc = 'illuminate goto_prev_reference',
        },
      },
    },
  },
  cmd = { 'TSUpdateSync', 'TSUpdate', 'TSInstall' },
  keys = {
    { '<S-space>', desc = 'Increment selection' },
    { '<bs>', desc = 'Decrement selection', mode = 'x' },
  },

  opts = {
    ensure_installed = {
      'lua',
      'go',
      'gomod',
      'templ',
      'rust',
      'markdown',
      'toml',
      'javascript',
      'typescript',
      'tsx',
      'bash',
      'json',
      'dockerfile',
      'python',
      'vim',
      'html',
      'yaml',
      'terraform',
      'hcl',
    },
    auto_install = true,

    highlight = {
      enable = true,
    },
    indent = {
      enable = true,
    },

    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = '<S-space>',
        node_incremental = '<S-space>',
        scope_incremental = false,
        node_decremental = '<bs>',
      },
    },

    textobjects = {
      move = {
        enable = true,
        set_jumps = true, -- whether to set jumps in the jumplist
        goto_next_start = {
          [']f'] = { query = '@function.outer', desc = 'TS: goto_next_start => @function.outer' },
          [']]'] = { query = '@class.outer', desc = 'TS: goto_next_start => @class.outer' },
        },
        goto_next_end = {
          [']F'] = { query = '@function.outer', desc = 'TS: goto_next_end => @function.outer' },
          [']['] = { query = '@class.outer', desc = 'TS: goto_next_end => @class.outer' },
        },
        goto_previous_start = {
          ['[f'] = { query = '@function.outer', desc = 'TS: goto_previous_start => @function.outer' },
          ['[['] = { query = '@class.outer', desc = 'TS: goto_previous_start => @class.outer' },
        },
        goto_previous_end = {
          ['[F'] = { query = '@function.outer', desc = 'TS: goto_previous_end => @function.outer' },
          ['[]'] = { query = '@class.outer', desc = 'TS: goto_previous_end => @class.outer' },
        },
      },

      select = {
        enable = true,
        -- Automatically jump forward to textobj, similar to targets.vim
        lookahead = true,
        keymaps = {
          ['af'] = { query = '@function.outer', desc = 'TS: select => @function.outer' },
          ['if'] = { query = '@function.inner', desc = 'TS: select => @function.inner' },
          ['ac'] = { query = '@class.outer', desc = 'TS: select => @class.outer' },
          ['ic'] = { query = '@class.inner', desc = 'TS: select => @class.inner' },
        },
      },
    },

    matchup = {
      enable = true,
    },

    autotag = {
      enable = true,
    },
  },
}
