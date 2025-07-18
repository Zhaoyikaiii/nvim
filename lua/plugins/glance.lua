return {
    "dnlhc/glance.nvim",
    config = function()
        vim.keymap.set(
            "n",
            "gr",
            "<cmd>Glance references<CR>",
            { noremap = true, silent = true, desc = "Find References (Glance)" }
        )
        vim.keymap.set(
            "n",
            "gd",
            "<cmd>Glance definitions<CR>",
            { noremap = true, silent = true, desc = "Peek Definition (Glance)" }
        )
    end,
}
