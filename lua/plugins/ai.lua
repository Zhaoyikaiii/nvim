return {
  {
    "johnseth97/codex.nvim",
    lazy = true,
    cmd = { "OpenCode", "OpenCodeToggle" },
    keys = {
      {
        "<leader>aa",
        function()
          require("codex").toggle()
        end,
        desc = "Toggle Codex",
        mode = { "n", "t" },
      },
    },
    opts = {
      keymaps = {
        toggle = nil,
        quit = "<C-q>",
      },
      border = "rounded",
      width = 0.6,
      height = 0.8,
      model = nil,
      autoinstall = true,
      panel = false,
      use_buffer = false,
      name = "Codex",
      pkg_name = "Codex",
      cmd = "codex",
    },
  },
}
