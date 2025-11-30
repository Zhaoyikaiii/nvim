return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/neotest-go",
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "nvim-neotest/nvim-nio", -- 添加缺失的依赖
  },
  config = function()
    -- get neotest namespace (api call creates or returns namespace)
    local neotest_ns = vim.api.nvim_create_namespace("neotest")
    vim.diagnostic.config({
      virtual_text = {
        format = function(diagnostic)
          local message =
            diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
          return message
        end,
      },
    }, neotest_ns)
    require("neotest").setup({
      adapters = {
        require("neotest-go")({
          args = { "-coverprofile=coverage.out" },
        }),
      },
      -- Configure neotest settings
      discovery = {
        enabled = true,
      },
      running = {
        concurrent = true,
      },
      summary = {
        open = "topleft",
        mappings = {
          attach = "a",
          expand = { "<CR>", "<2-LeftMouse>" },
          expand_all = "e",
          jumpto = "i",
          run = "r",
          run_marked = "R",
          short = "o",
          stop = "u",
          clear_target = "U",
          clear_marked = "C",
        },
      },
      output = {
        open_on_run = true,
        enabled = true,
      },
      status = {
        enabled = true,
        virtual_text = true,
      },
    })
  end,
}