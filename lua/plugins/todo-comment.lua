return {
  {
    'folke/todo-comments.nvim',
    event = 'VeryLazy',
    cmd = { 'TodoTrouble', 'TodoTelescope' },
    config = true,
    keys = {
      {
        ']t',
        function()
          require('todo-comments').jump_next()
        end,
        mode = 'n',
        desc = 'TODO jump next',
      },
      {
        '[t',
        function()
          require('todo-comments').jump_prev()
        end,
        mode = 'n',
        desc = 'TODO jump prev',
      },
      {
        '<leader>ft',
        [[<cmd>TodoTelescope<cr>]],
        mode = 'n',
        desc = 'workspace TODOs in Telescope',
      },
    },
    -- FIX:
    -- TODO:
    -- HACK:
    -- WARN:
    -- PERF:
    -- NOTE:
    -- TEST:
  },

  {
    'folke/trouble.nvim',
    cmd = { 'TroubleToggle', 'Trouble' },
    opts = { use_diagnostic_signs = true },
    keys = {
      { '<leader>xx', '<cmd>TroubleToggle document_diagnostics<cr>', desc = 'Document Diagnostics (Trouble)' },
      { '<leader>xw', '<cmd>TroubleToggle workspace_diagnostics<cr>', desc = 'Workspace Diagnostics (Trouble)' },
      { '<leader>xl', '<cmd>TroubleToggle loclist<cr>', desc = 'Location List (Trouble)' },
      { '<leader>xq', '<cmd>TroubleToggle quickfix<cr>', desc = 'Quickfix List (Trouble)' },
      {
        '[q',
        function()
          if require('trouble').is_open() then
            require('trouble').previous({ skip_groups = true, jump = true })
          else
            -- cprev with jumping back to the last when 'no more items'
            local ok, err = pcall(vim.cmd, [[try | cprev | catch | clast | catch | endtry]])
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end,
        desc = 'Previous trouble/quickfix item',
      },
      {
        ']q',
        function()
          if require('trouble').is_open() then
            require('trouble').next({ skip_groups = true, jump = true })
          else
            -- cnext with jumping back to the first when 'no more items'
            local ok, err = pcall(vim.cmd, [[try | cnext | catch | cfirst | catch | endtry]])
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end,
        desc = 'Next trouble/quickfix item',
      },
    },
  },
}
