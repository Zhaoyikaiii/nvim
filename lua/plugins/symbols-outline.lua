-- 暂时禁用 symbols-outline.nvim，因为它存在 JSX 解析错误
-- 使用更稳定的替代方案：aerial.nvim

return {
  -- 使用 aerial.nvim 作为替代方案，它更稳定且功能相似
  "stevearc/aerial.nvim",
  opts = {
    -- 在右侧显示符号树
    layout = {
      placement = "right",
      width = 30,
    },
    -- 自动关联 LSP 客户端
    attach_mode = "global",
    -- 启用后端
    backends = { "lsp", "treesitter", "markdown", "man" },
    -- 显示过滤器
    filter_kind = {
      -- 默认显示的符号类型
      "Class",
      "Constructor",
      "Enum",
      "Function",
      "Interface",
      "Module",
      "Method",
      "Struct",
    },
    -- 显示图标的设置
    show_guides = true,
    guides = {
      mid_item = "├─",
      last_item = "└─",
      nested_top_level = "│ ",
      whitespace = "  ",
    },
    -- 键位映射
    keymaps = {
      ["?"] = "actions.show_help",
      ["g?"] = "actions.show_help",
      ["<CR>"] = "actions.jump",
      ["<2-LeftMouse>"] = "actions.jump",
      ["<C-v>"] = "actions.jump_vsplit",
      ["<C-s>"] = "actions.jump_split",
      ["p"] = "actions.scroll",
      ["<C-z>"] = "actions.zoom",
      ["{"] = "actions.prev",
      ["}"] = "actions.next",
      ["[["] = "actions.prev_up",
      ["]]"] = "actions.next_up",
      ["q"] = "actions.close",
    },
  },
  -- 确保 LSP 启动后再加载
  dependencies = {
    "neovim/nvim-lspconfig",
    "nvim-treesitter/nvim-treesitter",
  },
  -- 延迟加载
  lazy = true,
  -- 只在支持的文件类型中启用
  ft = { "lua", "python", "go", "java", "c", "cpp", "rust", "javascript", "typescript", "javascriptreact", "typescriptreact" },
  -- 设置快捷键
  keys = {
    { "<leader>cs", "<cmd>AerialToggle<CR>", desc = "Toggle Aerial" },
    { "<leader>co", "<cmd>AerialToggle<CR>", desc = "Toggle Aerial" },
  },
}