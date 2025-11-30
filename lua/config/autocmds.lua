-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- 确保 Copilot 正确初始化
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    if package.loaded["copilot"] then
      require("copilot.suggestion").is_hidden = function()
        return false -- 确保建议始终可见
      end
    end
  end,
})

-- 设置补全行为
vim.api.nvim_create_autocmd("InsertEnter", {
  callback = function()
    -- 禁用自动选择第一个补全项
    vim.b.copilot_suggestion_hidden = false
  end,
})
