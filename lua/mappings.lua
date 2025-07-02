require("nvchad.mappings")

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

-- harpoon mappings
-- lua/custom/mappings.lua

local harpoon = require("harpoon")

-- 添加一个文件到 Harpoon 列表
vim.keymap.set("n", "<leader>a", function()
    harpoon:list():add()
end, { desc = "Harpoon: Add file" })

-- 打开/关闭 Harpoon 的快捷菜单
vim.keymap.set("n", "<leader>e", function()
    harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = "Harpoon: Quick Menu" })

-- 快速跳转到第 1/2/3/4 个标记的文件
vim.keymap.set("n", "<leader>1", function()
    harpoon:list():select(1)
end, { desc = "Harpoon: Go to mark 1" })
vim.keymap.set("n", "<leader>2", function()
    harpoon:list():select(2)
end, { desc = "Harpoon: Go to mark 2" })
vim.keymap.set("n", "<leader>3", function()
    harpoon:list():select(3)
end, { desc = "Harpoon: Go to mark 3" })
vim.keymap.set("n", "<leader>4", function()
    harpoon:list():select(4)
end, { desc = "Harpoon: Go to mark 4" })

-- 也可以用其他顺手的键，比如 Ctrl + H/J/K/L
-- vim.keymap.set("n", "<C-h>", function() harpoon:list():select(1) end, { desc = "Harpoon: Go to mark 1" })
-- vim.keymap.set("n", "<C-j>", function() harpoon:list():select(2) end, { desc = "Harpoon: Go to mark 2" })
-- vim.keymap.set("n", "<C-k>", function() harpoon:list():select(3) end, { desc = "Harpoon: Go to mark 3" })
-- vim.keymap.set("n", "<C-l>", function() harpoon:list():select(4) end, { desc = "Harpoon: Go to mark 4" })

-- 在 Harpoon 菜单中，你也可以设置快捷键来编辑列表
-- 比如在菜单打开时，按 'd' 删除标记，按 's' 交换位置等
