-- nvim-lint: async linting
return {
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    config = function()
      local lint = require("lint")

      -- Point golangcilint to the mason-installed binary
      local golangci_bin = vim.fn.stdpath("data") .. "/mason/bin/golangci-lint"
      if vim.fn.executable(golangci_bin) == 1 then
        lint.linters.golangcilint.cmd = golangci_bin
      end

      lint.linters_by_ft = {
        go         = { "golangcilint" },
        python     = { "ruff" },
        javascript = { "eslint_d" },
        typescript = { "eslint_d" },
        typescriptreact = { "eslint_d" },
        javascriptreact = { "eslint_d" },
      }

      -- Auto-lint on save and read
      local lint_augroup = vim.api.nvim_create_augroup("nvim_lint", { clear = true })
      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
        group = lint_augroup,
        callback = function()
          lint.try_lint()
        end,
      })

      vim.keymap.set("n", "<leader>cl", function()
        lint.try_lint()
      end, { desc = "Trigger lint" })
    end,
  },
}
