-- Mason: external tool installer
return {
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    opts = {
      ensure_installed = {
        -- Go
        "gopls", "goimports", "golangci-lint",
        -- Python
        "basedpyright", "ruff",
        -- TypeScript / JS
        "vtsls", "eslint_d", "prettier",
        -- Lua
        "lua-language-server",
        -- Generic
        "stylua",
      },
      ui = { border = "rounded" },
    },
    config = function(_, opts)
      require("mason").setup(opts)
      -- Auto-install ensure_installed list
      local mr = require("mason-registry")
      mr.refresh(function()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end)
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {},
  },
}
