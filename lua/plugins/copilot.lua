return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    build = ":Copilot auth",
    event = "InsertEnter",
    opts = {
      suggestion = {
        enabled = true,
        auto_trigger = true,
        hide_during_completion = false,
        debounce = 75,
        keymap = {
          accept = "<Tab>", -- 恢复默认的 Tab 键
          accept_word = false,
          accept_line = false,
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-]>",
        },
      },
      panel = { enabled = false },
      filetypes = {
        markdown = true,
        help = true,
        ["*"] = true,
      },
      server_opts_overrides = {},
    },
  },

  -- 确保LSP服务正常运行以提供真实API
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      -- 确保LSP服务器正确配置以提供准确的补全
      opts.servers = opts.servers or {}

      -- 常见语言的LSP服务器配置
      local servers = {
        "gopls", -- Go
        "pyright", -- Python
        "tsserver", -- TypeScript/JavaScript
        "rust_analyzer", -- Rust
        "clangd", -- C/C++
        "lua_ls", -- Lua
      }

      for _, server in ipairs(servers) do
        if not opts.servers[server] then
          opts.servers[server] = {}
        end
      end

      return opts
    end,
  },
}