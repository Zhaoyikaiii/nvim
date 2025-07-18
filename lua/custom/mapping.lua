-- ~/.config/nvim/lua/custom/mappings.lua

-- 定义一个名为 M 的 table
local M = {}

-- M.general.n 指的是 Normal 模式下的通用快捷键
M.n = {
    n = {
        -- 移除这两行来恢复 ; 和 , 的默认功能
        -- [";"] = { "" },
        -- [","] = { "" },
    },
}

-- 必须返回这个 M table，NvChad 的加载器需要它
return M
