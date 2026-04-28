-- nvim-lint: async linting
return {
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    config = function()
      local lint = require("lint")

      -- Point golangcilint to the mason-installed binary and fix args for v2
      local golangci_bin = vim.fn.stdpath("data") .. "/mason/bin/golangci-lint"
      if vim.fn.executable(golangci_bin) ~= 1 then
        golangci_bin = "golangci-lint"
      end
      lint.linters.golangcilint.cmd = golangci_bin
      -- Rebuild args for golangci-lint v2 (args is computed at module load time
      -- with the wrong binary, so we override it here explicitly)
      lint.linters.golangcilint.args = function()
        local go_mod = vim.fn.system({ "go", "env", "GOMOD" }):gsub("%s+", "")
        local modifier = (go_mod == "/dev/null" or go_mod == "") and ":p" or ":h"
        return {
          "run",
          "--output.json.path=stdout",
          "--output.text.path=",
          "--output.tab.path=",
          "--output.html.path=",
          "--output.checkstyle.path=",
          "--output.code-climate.path=",
          "--output.junit-xml.path=",
          "--output.teamcity.path=",
          "--output.sarif.path=",
          "--issues-exit-code=0",
          "--show-stats=false",
          "--path-mode=abs",
          vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), modifier),
        }
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
