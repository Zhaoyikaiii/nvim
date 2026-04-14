-- AI: copilot.lua + codecompanion.nvim
return {
  -- GitHub Copilot (modern Lua client)
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
      suggestion = {
        enabled = true,
        auto_trigger = true,
        keymap = {
          accept        = "<M-l>",
          accept_word   = "<M-w>",
          accept_line   = "<M-j>",
          next          = "<M-]>",
          prev          = "<M-[>",
          dismiss       = "<M-e>",
        },
      },
      panel = { enabled = false },
      filetypes = {
        yaml     = true,
        markdown = true,
        help     = false,
        gitcommit = false,
        ["*"] = true,
      },
    },
  },

  -- AI coding assistant: chat, edit, agent
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionActions" },
    keys = {
      { "<leader>aa", "<cmd>CodeCompanionActions<cr>",      mode = { "n", "v" }, desc = "AI actions" },
      { "<leader>ac", "<cmd>CodeCompanionChat Toggle<cr>",  mode = { "n", "v" }, desc = "AI chat toggle" },
      { "<leader>ai", "<cmd>CodeCompanion<cr>",             mode = { "n", "v" }, desc = "AI inline" },
      { "ga",         "<cmd>CodeCompanionChat Add<cr>",     mode = "v",          desc = "Add to AI chat" },
    },
    opts = {
      strategies = {
        chat   = { adapter = "copilot" },
        inline = { adapter = "copilot" },
        agent  = { adapter = "copilot" },
      },
      display = {
        chat = {
          window = {
            layout = "vertical",
            width = 0.35,
          },
        },
      },
    },
  },
}
