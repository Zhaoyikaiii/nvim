-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.opt.relativenumber = false

-- 设置补全选项
vim.opt.completeopt = "menu,menuone,noinsert,noselect"

-- 设置补全行为
vim.opt.shortmess = vim.opt.shortmess + { c = true } -- 禁止显示补全已完成的消息

-- 设置建议选项
vim.opt.wildmenu = true
vim.opt.wildmode = "longest,full"
