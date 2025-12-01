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
          accept = "<Tab>",
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

  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = opts.servers or {}

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
