-- Git: gitsigns, fugitive, diffview
return {
  -- Line-level diff, stage/reset hunk, blame
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add          = { text = "▎" },
        change       = { text = "▎" },
        delete       = { text = "" },
        topdelete    = { text = "" },
        changedelete = { text = "▎" },
        untracked    = { text = "▎" },
      },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        local map = function(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = bufnr, desc = "Git: " .. desc })
        end

        -- Navigation
        map("n", "]h", gs.next_hunk,      "Next hunk")
        map("n", "[h", gs.prev_hunk,      "Prev hunk")

        -- Staging
        map({ "n", "v" }, "<leader>gs", ":Gitsigns stage_hunk<cr>",  "Stage hunk")
        map({ "n", "v" }, "<leader>gr", ":Gitsigns reset_hunk<cr>",  "Reset hunk")
        map("n", "<leader>gS", gs.stage_buffer,                       "Stage buffer")
        map("n", "<leader>gu", gs.undo_stage_hunk,                    "Undo stage hunk")
        map("n", "<leader>gR", gs.reset_buffer,                       "Reset buffer")

        -- Viewing
        map("n", "<leader>gp", gs.preview_hunk,                       "Preview hunk")
        map("n", "<leader>gb", function() gs.blame_line({ full = true }) end, "Blame line")
        map("n", "<leader>gB", gs.toggle_current_line_blame,          "Toggle line blame")
        map("n", "<leader>gd", gs.diffthis,                           "Diff this")

        -- Text object
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<cr>", "Select hunk")
      end,
    },
  },

  -- Git command workbench
  {
    "tpope/vim-fugitive",
    cmd = { "Git", "G", "Gdiffsplit", "Gread", "Gwrite", "GBrowse" },
    keys = {
      { "<leader>gg", "<cmd>Git<cr>",         desc = "Git status (fugitive)" },
      { "<leader>gc", "<cmd>Git commit<cr>",  desc = "Git commit" },
      { "<leader>gP", "<cmd>Git push<cr>",    desc = "Git push" },
      { "<leader>gl", "<cmd>Git log<cr>",     desc = "Git log" },
    },
  },

  -- Diff browser (commit/branch/file)
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles", "DiffviewFileHistory" },
    keys = {
      { "<leader>gD", "<cmd>DiffviewOpen<cr>",            desc = "Diffview open" },
      { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>",   desc = "File history" },
    },
    opts = {},
  },
}
