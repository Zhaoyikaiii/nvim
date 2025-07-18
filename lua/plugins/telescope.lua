return {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.x",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local builtin = require("telescope.builtin")
        vim.keymap.set("n", "gr", builtin.lsp_references, { noremap = true, silent = true, desc = "Find References" })
        vim.keymap.set("n", "gd", builtin.lsp_definitions, { noremap = true, silent = true, desc = "Goto Definition" })
        vim.keymap.set("n", "<leader>ff", builtin.find_files, { noremap = true, silent = true, desc = "Find Files" })
    end,
}
