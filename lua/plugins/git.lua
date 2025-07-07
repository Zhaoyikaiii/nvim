return {
    "NeogitOrg/neogit",

    dependencies = {
        "nvim-lua/plenary.nvim",
        "sindrets/diffview.nvim",
        "nvim-telescope/telescope.nvim",
    },

    cmd = "Neogit",

    config = function()
        local neogit = require("neogit")

        neogit.setup({
            disable_hint = false,
            remember_window_size = true,
            kind = "floating",
            integrations = {
                diffview = true,
                telescope = true,
            },
            commit_editor = {
                kind = "vsplit",
            },
            commit_view = {
                kind = "tab",
            },
        })
    end,
}
