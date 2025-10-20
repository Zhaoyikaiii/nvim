-- LSP configuration with rust-analyzer memory optimization
return {
  -- Configure rust-analyzer with memory optimizations
  {
    "neovim/nvim-lspconfig",
    opts = {
      diagnostics = {
        underline = true,
        update_in_insert = false,
        virtual_text = {
          spacing = 4,
          source = "if_many",
          prefix = "●",
        },
        severity_sort = true,
      },
      inlay_hints = {
        enabled = false, -- Disable inlay hints to reduce memory
      },
      codelens = {
        enabled = false, -- Disable code lens to reduce memory
      },
      -- Configure rust-analyzer specifically
      servers = {
        rust_analyzer = {
          settings = {
            ["rust-analyzer"] = {
              -- Memory optimization settings
              cargo = {
                loadOutDirsFromCheck = false, -- Don't load output directories
              },
              procMacro = {
                enable = false, -- Disable proc macros (saves memory)
              },
              checkOnSave = {
                command = "clippy", -- Use clippy for better performance
                extraArgs = { "--all-targets", "--", "-W", "clippy::all" },
              },
              diagnostics = {
                enable = true,
                disabled = { "unresolved-proc-macro" }, -- Disable proc macro diagnostics
              },
              completion = {
                addCallParentheses = false, -- Disable auto parentheses
                addCustomArgumentCompletionMarkers = false,
              },
              hover = {
                actions = {
                  enable = false, -- Disable hover actions
                },
              },
              -- Memory-specific optimizations
              files = {
                watcher = "notify", -- Use more efficient file watcher
                excludeDirs = { "target", ".git", "node_modules" },
              },
              indexing = {
                enable = true,
                memoryUsage = "low", -- Explicit memory usage setting
                projectDiscovery = {
                  enable = false, -- Disable auto project discovery
                },
              },
              semanticHighlighting = {
                strings = {
                  enable = false, -- Disable string highlighting
                },
              },
              -- Disable expensive features
              lens = {
                enable = false, -- Disable code lens completely
                run = {
                  enable = false,
                },
                debug = {
                  enable = false,
                },
                implementations = {
                  enable = false,
                },
                references = {
                  enable = false,
                },
                methodReferences = {
                  enable = false,
                },
              },
              -- Reduce concurrent operations
              lru = {
                capacity = 128, -- Reduce LRU cache capacity
              },
              workspace = {
                symbol = {
                  search = {
                    limit = 1000, -- Limit symbol search results
                  },
                },
              },
            },
          },
        },
      },
    },
  },

  -- Configure mason.nvim for LSP management
  {
    "williamboman/mason.nvim",
    opts = {
      max_concurrent_installers = 1, -- Limit concurrent installations
    },
  },

  -- Configure null-ls for formatting (lighter than full LSP formatters)
  {
    "nvimtools/none-ls.nvim",
    opts = function(_, opts)
      opts = opts or {}
      opts.sources = opts.sources or {}
      -- Use rustfmt for formatting only when needed
      if vim.fn.executable("rustfmt") == 1 then
        local null_ls = require("null-ls")
        table.insert(opts.sources, null_ls.builtins.formatting.rustfmt)
      end
      return opts
    end,
  },

  -- Configure telescope for code actions (on-demand instead of always active)
  {
    "nvim-telescope/telescope.nvim",
    opts = {
      pickers = {
        lsp_references = {
          theme = "dropdown",
          previewer = false, -- Disable previewer to save memory
        },
        lsp_definitions = {
          theme = "dropdown",
          previewer = false,
        },
        lsp_implementations = {
          theme = "dropdown",
          previewer = false,
        },
      },
    },
  },

  -- Auto-save configuration to reduce LSP load
  {
    "okuuva/auto-save.nvim",
    opts = {
      trigger_events = { "InsertLeave", "BufLeave" }, -- Less frequent saves
      debounce_delay = 2000, -- Increase debounce to reduce LSP calls
    },
  },
}