return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    "fredrikaverpil/neotest-golang",
  },
  config = function()

    require("neotest").setup({
      adapters = {
        require("neotest-golang")({
          go_test_args = {
            "-v",
            "-race",
            "-count=1",
            "-timeout=60s",
          },
          dap_go_enabled = true,
          warn_test_name_dupes = false,
        }),
      },
      status = {
        virtual_text = true,
        signs = true,
      },

      output = {
        open_on_run = true,
      },

      summary = {
        open = "botright vsplit | vertical resize 50",
      },
    })
  end,
  keys = {
    { "<leader>tt", function() require("neotest").run.run() end, desc = "Run Nearest" },
    { "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run File" },
    { "<leader>to", function() require("neotest").output.open({ enter = true }) end, desc = "Show Output" },
    { "<leader>ts", function() require("neotest").summary.toggle() end, desc = "Toggle Summary" },
  },
}
