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

    {
        "NeogitOrg/neogit",
        dependencies = {
            "nvim-lua/plenary.nvim", -- required
            "sindrets/diffview.nvim", -- optional - for better diff viewing
            "nvim-telescope/telescope.nvim", -- optional
        },
        config = true,
    },

    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
        config = function()
            require("copilot").setup({
                suggestion = {
                    enabled = true,
                    auto_trigger = true,
                    keymap = {
                        accept = "<Tab>", -- 使用 Tab 键接受建议
                        next = "<C-j>", -- 查看下一个建议
                        prev = "<C-k>", -- 查看上一个建议
                        dismiss = "<C-e>", -- 关闭建议
                    },
                },
                panel = { enabled = false }, -- 可以用 :Copilot panel 打开一个窗口查看多个建议
            })
        end,
    },
    {
        "zbirenbaum/copilot-cmp",
        config = function()
            require("copilot_cmp").setup()
        end,
    },

    {
        "hrsh7th/nvim-cmp",
        opts = function(_, opts)
            local cmp = require("cmp")
            table.insert(opts.sources, 1, { name = "copilot" })
            opts.mapping["<Down>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select })
            opts.mapping["<Up>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select })
            return opts
        end,
    },

    {
        "hrsh7th/nvim-cmp",
        opts = function(_, opts)
            local cmp = require("cmp")
            table.insert(opts.sources, 1, { name = "copilot" })
            opts.mapping["<Down>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select })
            opts.mapping["<Up>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select })
            return opts
        end,
    },

    {
        "NeogitOrg/neogit",

        -- [必需] 声明所有依赖
        dependencies = {
            "nvim-lua/plenary.nvim", -- [必需] Neogit 的核心依赖库
            "sindrets/diffview.nvim", -- [推荐] 提供强大的分屏 diff 功能
            "nvim-telescope/telescope.nvim", -- [推荐] 用于模糊搜索 Git 日志等
        },

        -- [必需] 设置懒加载触发命令
        cmd = "Neogit",

        -- [核心] 插件的主要配置
        config = function()
            -- 首先获取 neogit 模块
            local neogit = require("neogit")

            -- 调用 setup 函数进行详细配置
            neogit.setup({
                -- [UI/UX] 关闭启动时的欢迎提示，熟练后可以设为 true
                disable_hint = false,

                -- [UI/UX] 记住上次 Neogit 窗口的大小
                remember_window_size = true,

                -- [UI/UX] 默认使用浮动窗口打开，视觉效果更好。你也可以改为 'tab' 或 'split'
                kind = "floating",

                -- [核心] Neogit 内部窗口的快捷键映射
                mappings = {
                    -- Status 状态窗口中的按键
                    status = {
                        -- s: 暂存 (Stage)
                        ["s"] = "Stage",
                        -- u: 取消暂存 (Unstage)
                        ["u"] = "Unstage",
                        -- c: 提交 (Commit)
                        ["c"] = "Commit",
                        -- p: 推送 (Push)
                        ["p"] = "Push",
                        -- P: 拉取 (Pull)
                        ["P"] = "Pull",
                        -- $: 储藏 (Stash)
                        ["$"] = "Stash",
                        -- r: 变基 (Rebase)
                        ["r"] = "Rebase",
                        -- <Tab>: 在不同区域（未暂存、已暂存、最近提交等）之间切换
                        ["<tab>"] = "Toggle",
                        -- <c-r>: 强制刷新 Git 状态
                        ["<c-r>"] = "Refresh",
                    },
                },

                -- [集成] 与其他插件的集成配置
                integrations = {
                    -- [推荐] 启用 diffview.nvim 集成
                    -- 启用后，在 Neogit 中对 commit 或 hunk 按 'd' 或 '<c-d>' 会用 diffview 打开
                    diffview = true,

                    -- [推荐] 启用 telescope.nvim 集成
                    -- 启用后，会添加 :Neogit telescope git_commits 等命令
                    telescope = true,
                },

                -- [可选] 对特定窗口类型的进一步定制
                commit_editor = {
                    kind = "vsplit", -- 提交 commit message 时，使用垂直分屏
                },
                commit_view = {
                    kind = "tab", -- 查看单个 commit 的详情时，在新标签页中打开
                },
            })

            -- [核心] 设置一些全局快捷键，方便从任何地方调用 Neogit
            -- 注意: 'n' 代表 Normal 模式, <leader> 是你的前导键 (通常是 '\' 或 '空格')

            -- 打开 Neogit 主窗口
            vim.keymap.set("n", "<leader>gg", function()
                neogit.open()
            end, { silent = true, desc = "[G]it: Open Neogit" })

            -- 查看当前分支的提交日志 (会打开 Neogit 并切换到 log 视图)
            vim.keymap.set("n", "<leader>gl", function()
                neogit.open({ "log" })
            end, { silent = true, desc = "[G]it: View [L]og" })

            -- 查看当前光标下文件的提交历史
            vim.keymap.set("n", "<leader>gf", function()
                neogit.open({ "log", vim.fn.expand("%") })
            end, { silent = true, desc = "[G]it: View [F]ile History" })

            -- 快速打开变基 (rebase) 视图
            vim.keymap.set("n", "<leader>gr", function()
                neogit.open({ "rebase" })
            end, { silent = true, desc = "[G]it: [R]ebase" })

            -- 直接打开 Stash 视图
            vim.keymap.set("n", "<leader>gs", function()
                neogit.open({ "stash" })
            end, { silent = true, desc = "[G]it: [S]tash" })
        end,
    },
    {
        "arnamak/stay-centered.nvim",
        event = "VeryLazy",
        config = function()
            require("stay-centered").setup({
                center_on_open = true,
                center_on_scroll = true,
            })
        end,
    },
    {
        "nvim-telescope/telescope-project.nvim",
        dependencies = { "nvim-telescope/telescope.nvim" },
        config = function()
            require("telescope").setup({
                extensions = {
                    project = {
                        base_dirs = {
                            "~/projects",
                            "~/.config",
                        },
                        theme = "dropdown",
                        hidden_files = true,
                    },
                },
            })
            require("telescope").load_extension("project")
        end,
    },
    {
        "ahmedkhalf/project.nvim",
        config = function()
            require("project_nvim").setup({
                -- detection_methods: 设置检测项目根目录的方式, "lsp" 和 "pattern" 通常足够了
                -- "lsp" 会使用LSP找到的根目录, "pattern" 会向上查找 .git, package.json 等标记
                detection_methods = { "lsp", "pattern" },

                -- patterns: "pattern" 方法查找的标记文件/文件夹
                patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "package.json" },
            })
        end,
    },
}
