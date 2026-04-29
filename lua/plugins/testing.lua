-- Testing & Debugging: neotest + nvim-dap for Go
return {
  -- ── Test Runner ───────────────────────────────────────────────────────────
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-neotest/nvim-nio",
      "nvim-neotest/neotest-go",
    },
    keys = {
      { "<leader>tt", function()
          require("neotest").run.run()
          require("neotest").summary.open()
        end, desc = "Run nearest test" },
      { "<leader>tf", function()
          require("neotest").run.run(vim.fn.expand("%"))
          require("neotest").summary.open()
        end, desc = "Run file tests" },
      { "<leader>tT", function()
          -- 找 go.mod 所在目录作为 root，而不是 cwd
          local root = require("neotest").state.adapter_ids and vim.loop.cwd() or vim.loop.cwd()
          -- 尝试向上找 go.mod
          local path = vim.fn.expand("%:p:h")
          while path ~= "/" do
            if vim.fn.filereadable(path .. "/go.mod") == 1 then
              root = path
              break
            end
            path = vim.fn.fnamemodify(path, ":h")
          end
          require("neotest").run.run(root)
          require("neotest").summary.open()
        end, desc = "Run all tests in module" },
      { "<leader>ts", function() require("neotest").summary.toggle() end,            desc = "Toggle test summary" },
      { "<leader>to", function() require("neotest").output.open({ enter = true, auto_close = true }) end, desc = "Show test output" },
      { "<leader>tO", function() require("neotest").output_panel.toggle() end,       desc = "Toggle output panel" },
      { "<leader>tS", function() require("neotest").run.stop() end,                  desc = "Stop test" },
      { "<leader>tw", function() require("neotest").watch.toggle(vim.fn.expand("%")) end, desc = "Watch file tests" },
    },
    opts = function()
      return {
        adapters = {
          require("neotest-go")({
            experimental = {
              test_table = false,  -- 关闭：复杂 query 在部分 parser 版本下会导致 discover_positions 失败
            },
            args = { "-count=1", "-timeout=60s" },
          }),
        },
        output = {
          open_on_run = "short",  -- 只在失败时自动打开
          enter = false,
        },
        output_panel = {
          enabled = true,
          open = "botright split | resize 12",
        },
        summary = {
          animated = true,
          enabled = true,
          expand_errors = true,
          follow = true,
          mappings = {
            attach = "a",
            clear_marked = "M",
            clear_target = "T",
            debug = "d",
            debug_marked = "D",
            expand = { "<CR>", "<2-LeftMouse>" },
            expand_all = "e",
            help = "?",
            jump = "i",
            mark = "m",
            next_failed = "J",
            output = "o",
            prev_failed = "K",
            run = "r",
            run_marked = "R",
            short = "O",
            stop = "u",
            target = "t",
            watch = "w",
          },
        },
        quickfix = {
          open = function()
            vim.cmd("Trouble qflist open")
          end,
        },
        status = {
          virtual_text = true,
          signs = true,
        },
        icons = {
          passed = "✓",
          failed = "✗",
          running = "↻",
          skipped = "○",
          unknown = "?",
        },
      }
    end,
  },

  -- ── DAP Core ──────────────────────────────────────────────────────────────
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      -- DAP UI
      {
        "rcarriga/nvim-dap-ui",
        dependencies = { "nvim-neotest/nvim-nio" },
        opts = {
          icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
          layouts = {
            {
              elements = {
                { id = "scopes",      size = 0.35 },
                { id = "breakpoints", size = 0.20 },
                { id = "stacks",      size = 0.25 },
                { id = "watches",     size = 0.20 },
              },
              size = 40,
              position = "left",
            },
            {
              elements = {
                { id = "repl",    size = 0.5 },
                { id = "console", size = 0.5 },
              },
              size = 12,
              position = "bottom",
            },
          },
          floating = {
            max_height = 0.9,
            max_width = 0.8,
            border = "rounded",
          },
        },
        config = function(_, opts)
          local dap, dapui = require("dap"), require("dapui")
          dapui.setup(opts)
          -- Auto open/close UI on debug events
          dap.listeners.after.event_initialized["dapui_config"] = function()
            dapui.open()
          end
          dap.listeners.before.event_terminated["dapui_config"] = function()
            dapui.close()
          end
          dap.listeners.before.event_exited["dapui_config"] = function()
            dapui.close()
          end
        end,
      },
      -- Virtual text for variables
      {
        "theHamsta/nvim-dap-virtual-text",
        opts = {
          commented = true,
          virt_text_pos = "eol",
        },
      },
    },
    keys = {
      { "<leader>db", function() require("dap").toggle_breakpoint() end,                                     desc = "Toggle breakpoint" },
      { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, desc = "Conditional breakpoint" },
      { "<leader>dc", function() require("dap").continue() end,                                              desc = "Continue / Start" },
      { "<leader>dn", function() require("dap").step_over() end,                                             desc = "Step over" },
      { "<leader>di", function() require("dap").step_into() end,                                             desc = "Step into" },
      { "<leader>do", function() require("dap").step_out() end,                                              desc = "Step out" },
      { "<leader>dr", function() require("dap").repl.toggle() end,                                           desc = "Toggle REPL" },
      { "<leader>dl", function() require("dap").run_last() end,                                              desc = "Run last" },
      { "<leader>du", function() require("dapui").toggle() end,                                              desc = "Toggle DAP UI" },
      { "<leader>de", function() require("dapui").eval() end,                                                desc = "Eval expression",    mode = { "n", "v" } },
      { "<leader>dq", function() require("dap").terminate() end,                                             desc = "Terminate" },
    },
  },

  -- ── DAP for Go (delve) ────────────────────────────────────────────────────
  {
    "leoluz/nvim-dap-go",
    ft = "go",
    dependencies = { "mfussenegger/nvim-dap" },
    opts = {
      dap_configurations = {
        {
          type = "go",
          name = "Attach remote",
          mode = "remote",
          request = "attach",
        },
      },
      delve = {
        path = "dlv",
        initialize_timeout_sec = 20,
        port = "${port}",
        args = {},
        build_flags = "",
        detached = vim.fn.has("win32") == 0,
      },
    },
    keys = {
      { "<leader>dgt", function() require("dap-go").debug_test() end,        desc = "Debug Go test (nearest)" },
      { "<leader>dgl", function() require("dap-go").debug_last_test() end,   desc = "Debug last Go test" },
    },
  },

  -- ── Mason: install delve ──────────────────────────────────────────────────
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "delve" })
    end,
  },
}
