-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- SSH 环境下 vim.ui.open 的自定义 handler
-- 通过 OSC52 将 URL 复制到本地剪贴板，方便在本地浏览器打开
vim.ui.open = function(path)
  -- 用 OSC52 转义序列将内容写入终端（会复制到本地剪贴板）
  local encoded = vim.base64.encode(path)
  local osc52 = string.format("\x1b]52;c;%s\x07", encoded)
  io.write(osc52)
  io.flush()
  vim.notify("已复制到剪贴板，请在本地浏览器中粘贴打开:\n" .. path, vim.log.levels.INFO)
  return nil, nil
end
