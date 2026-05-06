-- AI: codex.nvim
return {
  {
    "johnseth97/codex.nvim",
    lazy = true,
    cmd = { "Codex", "CodexToggle", "CodexContinueBuffer" },
    keys = {
      {
        "<leader>aa",
        function()
          require("codex").toggle()
        end,
        desc = "Toggle Codex",
        mode = { "n", "t" },
      },
      {
        "<leader>ac",
        function()
          require("codex").continue_with_buffer()
        end,
        desc = "Send Buffer Context To Codex",
        mode = { "n" },
      },
    },
    opts = {
      keymaps = {
        toggle = nil,
        context = nil,
        quit = "<C-q>",
      },
      border = "rounded",
      width = 0.6,
      height = 0.8,
      model = nil,
      autoinstall = true,
      panel = false,
      use_buffer = false,
      context = {
        max_lines = 200,
      },
    },
  },
}
