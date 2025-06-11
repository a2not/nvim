return {
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    event = { 'InsertEnter', 'VeryLazy' },
    opts = {
      suggestion = { enabled = false },
      panel = { enabled = false },
      filetypes = {
        markdown = true,
        help = true,
      },
    },
  },

  {
    'CopilotC-Nvim/CopilotChat.nvim',
    event = 'VeryLazy',
    build = 'make tiktoken',
    dependencies = {
      { 'zbirenbaum/copilot.lua' },
      { 'nvim-lua/plenary.nvim', branch = 'master' },
    },
    opts = {
      chat_autocomplete = false,
      prompts = {
        Commit = {
          prompt = 'Write a commit message for the change with commitizen convention as a prepending diff to `.git/COMMIT_EDITMSG`. Keep the title under 50 characters and wrap message at 72 characters.',
          context = 'git:staged',
        },
      },
    },
  },
}
