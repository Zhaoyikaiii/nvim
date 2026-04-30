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

-- 切换项目/工作目录时自动重启 LSP，解决切换 Go 项目后 gopls 仍用旧项目上下文导致语法错误的问题
vim.api.nvim_create_autocmd("DirChanged", {
  pattern = "*",
  callback = function()
    local cwd = vim.fn.getcwd()
    vim.schedule(function()
      -- 停止当前所有 LSP 客户端
      vim.lsp.stop_clients({ force = false })
      vim.notify("已切换到: " .. cwd .. "，LSP 正在重新启动...", vim.log.levels.INFO)
    end)
  end,
  desc = "Restart LSP on directory change to refresh project context",
})
