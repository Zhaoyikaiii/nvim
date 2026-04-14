-- which-key: keymap hint popup
return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "modern",
      spec = {
        { "<leader>c", group = "code" },
        { "<leader>f", group = "find/file" },
        { "<leader>g", group = "git" },
        { "<leader>b", group = "buffer" },
        { "<leader>q", group = "quit/session" },
        { "<leader>t", group = "test/debug" },
        { "<leader>x", group = "trouble/list" },
        { "<leader>a", group = "ai" },
      },
    },
  },
}
