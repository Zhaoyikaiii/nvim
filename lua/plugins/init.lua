return {

    {
        "nvim-treesitter/nvim-treesitter",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("configs.treesitter")
        end,
    },

    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("nvchad.configs.lspconfig").defaults()
            require("configs.lspconfig")
        end,
    },

    {
        "williamboman/mason-lspconfig.nvim",
        event = "VeryLazy",
        dependencies = { "nvim-lspconfig" },
        config = function()
            require("configs.mason-lspconfig")
        end,
    },

    {
        "mfussenegger/nvim-lint",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("configs.lint")
        end,
    },

    {
        "rshkarin/mason-nvim-lint",
        event = "VeryLazy",
        dependencies = { "nvim-lint" },
        config = function()
            require("configs.mason-lint")
        end,
    },

    {
        "stevearc/conform.nvim",
        event = "BufWritePre",
        config = function()
            require("configs.conform")
        end,
    },

    {
        "zapling/mason-conform.nvim",
        event = "VeryLazy",
        dependencies = { "conform.nvim" },
        config = function()
            require("configs.mason-conform")
        end,
    },
    {
        "ray-x/go.nvim",
        dependencies = {
            "ray-x/guihua.lua",
            "neovim/nvim-lspconfig",
            "nvim-treesitter/nvim-treesitter",
        },
        config = function()
            require("go").setup()
        end,
        event = { "CmdlineEnter" },
        ft = { "go", "gomod" },
        build = ':lua require("go.install").update_all_sync()',
    },
    {
        "mfussenegger/nvim-dap",
        -- event = "VeryLazy", -- 可以让它延迟加载，加快启动速度
        config = function()
            -- 在这里，我们可以安全地使用 require('dap')
            local dap = require("dap")

            -- ==========================================================
            --  ↓↓↓ 把你原来 go-dap.lua 文件的内容粘贴到这里 ↓↓↓
            -- ==========================================================
            dap.adapters.go = {
                type = "server",
                port = "${port}",
                executable = {
                    command = "dlv",
                    args = { "dap", "-l", "127.0.0.1:${port}" },
                },
            }

            dap.configurations.go = {
                {
                    type = "go",
                    name = "Debug (Launch)",
                    request = "launch",
                    program = "${fileDirname}",
                },
                {
                    type = "go",
                    name = "Debug test",
                    request = "launch",
                    mode = "test",
                    program = "${fileDirname}",
                },
                -- 你也可以添加更多的调试配置，比如附加到正在运行的进程
                -- {
                --   type = "go",
                --   name = "Attach to process",
                --   request = "attach",
                --   mode = "remote",
                -- },
            }
            -- ==========================================================
            --  ↑↑↑ Go DAP 配置到此结束 ↑↑↑
            -- ==========================================================

            -- 推荐：在这里定义你的DAP快捷键，确保它们只在dap加载后设置
            vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "DAP: Toggle Breakpoint" })
            vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "DAP: Continue" })
            vim.keymap.set("n", "<leader>do", dap.step_over, { desc = "DAP: Step Over" })
            vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "DAP: Step Into" })
            vim.keymap.set("n", "<leader>dO", dap.step_out, { desc = "DAP: Step Out" })
            vim.keymap.set("n", "<leader>dr", dap.repl.open, { desc = "DAP: Open REPL" })
        end,
    },
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("harpoon").setup({})
        end,
    },
}
