return {
  { import = "lazyvim.plugins.extras.lang.go" },
  -- Go-specific keymaps and utilities
  {
    "leoluz/nvim-dap-go",
    ft = "go",
    dependencies = "mfussenegger/nvim-dap",
    config = function(_, opts)
      require("dap-go").setup(opts)
    end,
  },
  -- Enhanced gopls configuration
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        gopls = {
          settings = {
            gopls = {
              gofumpt = true,
              codelenses = {
                gc_details = false,
                generate = true,
                regenerate_cgo = true,
                run_govulncheck = true,
                test = true,
                tidy = true,
                upgrade_dependency = true,
                vendor = true,
              },
              hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
              analyses = {
                nilness = true,
                unusedparams = true,
                unusedwrite = true,
                useany = true,
              },
              usePlaceholders = true,
              completeUnimported = true,
              staticcheck = true,
              directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
              semanticTokens = true,
            },
          },
        },
      },
      setup = {
        gopls = function(_, opts)
          -- workaround for gopls not supporting semanticTokensProvider
          -- https://github.com/golang/go/issues/54531#issuecomment-1464982242
          vim.api.nvim_create_autocmd("LspAttach", {
            callback = function(args)
              local client = vim.lsp.get_client_by_id(args.data.client_id)
              if client and client.name == "gopls" and not client.server_capabilities.semanticTokensProvider then
                local semantic = client.config.capabilities.textDocument.semanticTokens
                client.server_capabilities.semanticTokensProvider = {
                  full = true,
                  legend = {
                    tokenTypes = semantic.tokenTypes,
                    tokenModifiers = semantic.tokenModifiers,
                  },
                  range = true,
                }
              end
            end,
          })
          -- end workaround
        end,
      },
    },
  },
  -- Ensure Go tools are installed via mason
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "goimports",
        "gofumpt",
        "gomodifytags",
        "impl",
        "delve",
      })
      return opts
    end,
  },
  -- Enhanced conform.nvim configuration for Go
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        go = { "goimports", "gofumpt" },
      },
    },
  },
  -- Enhanced none-ls.nvim configuration for Go
  {
    "nvimtools/none-ls.nvim",
    optional = true,
    opts = function(_, opts)
      local nls = require("null-ls")
      opts.sources = vim.list_extend(opts.sources or {}, {
        nls.builtins.code_actions.gomodifytags,
        nls.builtins.code_actions.impl,
        nls.builtins.formatting.goimports,
        nls.builtins.formatting.gofumpt,
      })
      return opts
    end,
  },
  -- Enhanced DAP configuration for Go
  {
    "mfussenegger/nvim-dap",
    optional = true,
    dependencies = {
      {
        "williamboman/mason.nvim",
        opts = function(_, opts)
          opts.ensure_installed = opts.ensure_installed or {}
          vim.list_extend(opts.ensure_installed, { "delve" })
          return opts
        end,
      },
      {
        "leoluz/nvim-dap-go",
        opts = {},
      },
    },
  },
  -- Enhanced neotest configuration for Go
  {
    "nvim-neotest/neotest",
    optional = true,
    dependencies = {
      "fredrikaverpil/neotest-golang",
    },
    opts = {
      adapters = {
        ["neotest-golang"] = {
          -- Here we can set options for neotest-golang, e.g.
          -- go_test_args = { "-v", "-race", "-count=1", "-timeout=60s" },
          dap_go_enabled = true, -- requires leoluz/nvim-dap-go
        },
      },
    },
  },
  -- Enhanced mini.icons configuration for Go files
  {
    "echasnovski/mini.icons",
    opts = {
      file = {
        [".go-version"] = { glyph = "", hl = "MiniIconsBlue" },
      },
      filetype = {
        gotmpl = { glyph = "", hl = "MiniIconsGrey" },
      },
    },
  },
  -- Go snippets
  {
    "rafamadriz/friendly-snippets",
    optional = true,
    dependencies = { "L3MON4D3/LuaSnip" },
  },
  -- Go specific utilities
  {
    "crusj/structr.nvim",
    optional = true,
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    config = function()
      require("structr").setup({
        create_quiet = true,
      })
    end,
  },
  -- Go template highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, {
          "gomod",
          "gosum",
          "gotmpl",
          "gowork",
        })
      end
    end,
  },
  -- Improved Go testing
  {
    "nvim-neotest/neotest-go",
    optional = true,
    ft = "go",
    dependencies = { "nvim-neotest/neotest" },
  },
  -- Go context for go.mod files
  {
    "olexsmir/gopher.nvim",
    optional = true,
    ft = { "go", "gomod", "gosum" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function(_, opts)
      require("gopher").setup(opts)
    end,
    build = function()
      vim.cmd.GoInstallDeps()
    end,
  },
  -- Go package manager
  {
    "ray-x/go.nvim",
    optional = true,
    ft = { "go", "gomod" },
    dependencies = {
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("go").setup({
        lsp_cfg = true,
        lsp_inlay_hints = {
          enable = true,
        },
        goimports = "goimports",
        gofmt = "gofumpt",
        icons = { breakpoint = "🧘", currentpos = "🏃" },
      })
    end,
  },
  -- Better Go highlighting
  {
    "folke/lazy.nvim",
    optional = true,
    opts = function(_, opts)
      opts.change_detection.enabled = false
    end,
  },
}

