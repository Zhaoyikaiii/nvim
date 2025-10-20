-- Rust-specific optimizations for memory efficiency
return {
  -- Configure rustaceanvim with memory optimizations
  {
    "mrcjkb/rustaceanvim",
    version = "^4", -- Use stable version
    ft = { "rust" },
    opts = {
      -- Configure server with memory optimizations
      server = {
        autoload = true, -- Allow auto-load but with memory limits
        on_attach = function(client, bufnr)
          -- Minimal LSP attachments for memory
          local bufmap = function(mode, lhs, rhs)
            local opts = { buffer = bufnr, silent = true }
            vim.keymap.set(mode, lhs, rhs, opts)
          end

          -- Only essential keybindings
          bufmap("n", "gd", vim.lsp.buf.definition)
          bufmap("n", "K", vim.lsp.buf.hover)
          bufmap("n", "<leader>ca", vim.lsp.buf.code_action)

          -- Disable expensive features
          vim.lsp.inlay_hint.enable(false, { bufnr })
          client.server_capabilities.semanticTokensProvider = nil
        end,
        settings = {
          ["rust-analyzer"] = {
            -- Aggressive memory optimization
            cargo = {
              features = "all",
              loadOutDirsFromCheck = false,
            },
            -- Disable proc macros completely (major memory saver)
            procMacro = {
              enable = false,
              ignored = {
                ["async-trait"] = true,
                ["napi-derive"] = true,
                ["async-recursion"] = true,
                ["tokio"] = true,
                ["serde"] = true,
              },
            },
            check = {
              command = "clippy",
              extraArgs = {
                "--all-targets",
                "--",
                "-A", "clippy::all",
                "-W", "clippy::correctness",
                "-W", "clippy::suspicious",
              },
            },
            diagnostics = {
              enable = true,
              disabled = {
                "unresolved-proc-macro",
                "macro-error",
                "unresolved-import",
              },
              enableExperimental = false,
            },
            imports = {
              locate = {
                project = false, -- Don't index project imports
              },
            },
            completion = {
              limit = 20, -- Very low completion limit
              addCallParentheses = false,
              addCustomArgumentCompletionMarkers = false,
              importEnforceGranularity = false,
              importPreferAbsolute = false,
              autoimport = {
                enable = false, -- Disable auto imports
              },
            },
            -- Disable expensive features
            hover = {
              actions = {
                enable = false,
                implementations = {
                  enable = false,
                },
                references = {
                  enable = false,
                },
                run = {
                  enable = false,
                },
                debug = {
                  enable = false,
                },
              },
            },
            lens = {
              enable = false,
              run = {
                enable = false,
              },
              debug = {
                enable = false,
              },
              implementations = {
                enable = false,
              },
              methodReferences = {
                enable = false,
              },
              references = {
                enable = false,
              },
            },
            -- Memory-specific settings
            files = {
              watcher = "notify",
              excludeDirs = {
                "target",
                ".git",
                "node_modules",
                ".vscode",
                "dist",
                "build",
              },
            },
            indexing = {
              enable = true,
              memoryUsage = "low",
              projectDiscovery = {
                enable = false,
              },
              workspace = {
                excludeDirs = { "target", "node_modules" },
              },
            },
            semanticHighlighting = {
              strings = {
                enable = false,
              },
              punctuation = {
                enable = false,
              },
              specialize = {
                enable = false,
              },
            },
            -- Reduce caching aggressively
            lru = {
              capacity = 32, -- Extremely low cache
              query = {
                capacity = 16,
              },
              parse = {
                capacity = 16,
              },
            },
            workspace = {
              symbol = {
                search = {
                  limit = 200, -- Very low limit
                  kind = "all",
                },
              },
            },
          },
        },
        -- Use custom rust-analyzer command
        cmd = function()
          return { "rust-analyzer" }
        end,
      },
      -- Crates configuration
      crates = {
        enabled = false, -- Disable crates plugin for memory
      },
      -- Disable auto-start
      tools = {
        hover_actions = {
          replace_builtin_hover = false,
        },
        runnables = {
          use_telescope = false,
        },
        inlay_hints = {
          auto = false,
        },
        open_cargo_toml = {
          only_when_cargo_toml_exists = false,
        },
      },
      dap = {
        autoload_configurations = false, -- Disable auto DAP config
      },
    },
    config = function(_, opts)
      -- rust-analyzer will be started automatically when needed
      -- No manual startup required with current configuration
    end,
  },

  -- Configure treesitter with Rust-specific optimizations
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      table.insert(opts.ensure_installed, "rust")

      -- Optimize highlighting for large Rust files
      vim.filetype.add({
        extension = {
          rs = function(path, bufnr)
            -- Disable treesitter for very large files
            local size = vim.fn.getfsize(path)
            if size and size > 100 * 1024 then -- 100KB
              vim.bo[bufnr].syntax = "on"
              return "rust_off"
            end
            return "rust"
          end,
        },
      })
    end,
  },

  -- Add rust-specific keymaps for manual LSP control
  {
    "folke/which-key.nvim",
    opts = function(_, opts)
      local wk = require("which-key")

      wk.add({
        { "<leader>r", group = "Rust", icon = "󱘗 " },
        { "<leader>rr", "<cmd>RustAnalyzer restart<cr>", desc = "Restart Rust Analyzer" },
        { "<leader>rs", "<cmd>RustAnalyzer start<cr>", desc = "Start Rust Analyzer" },
        { "<leader>rx", "<cmd>RustAnalyzer stop<cr>", desc = "Stop Rust Analyzer" },
        { "<leader>rc", "<cmd>RustAnalyzer reload<cr>", desc = "Reload Workspace" },
        { "<leader>rm", "<cmd>lua vim.diagnostic.reset(nil, 0)<cr>", desc = "Clear Diagnostics" },
      })
    end,
  },
}