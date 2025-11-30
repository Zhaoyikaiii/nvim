-- 补全配置 -确保 LSP 补全正常工作
return {
  -- 检查并确保 blink.cmp 正确配置
  {
    "saghen/blink.cmp",
    enabled = true, -- 确保插件启用
    opts = {
      -- 使用 LazyVim 的默认配置
      -- 这里我们不做任何覆盖，让 LazyVim 处理所有默认行为
    },
  },
}