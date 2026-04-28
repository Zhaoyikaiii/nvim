-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- LSP Rename
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol" })

-- Copy file path with line number
vim.keymap.set("n", "<leader>cP", function()
  local path = vim.fn.expand("%:p")
  local line = vim.fn.line(".")
  local content = path .. ":" .. line
  -- Try system clipboard first, fallback to unnamed register
  local ok = pcall(vim.fn.setreg, "+", content)
  vim.fn.setreg('"', content)
  vim.fn.setreg("0", content)
  vim.notify(
    "Copied: " .. content .. (ok and "" or " (clipboard unavailable, use p to paste)"),
    vim.log.levels.INFO,
    { title = "Copy path" }
  )
end, { desc = "Copy file path with line" })
