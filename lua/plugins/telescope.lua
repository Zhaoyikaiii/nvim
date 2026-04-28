-- Telescope: unified fuzzy finder
return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    version = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        cond = function()
          return vim.fn.executable("make") == 1
        end,
      },
    },
    opts = function()
      local actions = require("telescope.actions")
      return {
        defaults = {
          prompt_prefix = "  ",
          selection_caret = " ",
          mappings = {
            i = {
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
              ["<esc>"] = actions.close,
            },
          },
          file_ignore_patterns = { "%.git/", "node_modules/", "%.cache/" },
          layout_config = { horizontal = { preview_width = 0.55 } },
          path_display = { "truncate" },
        },
        pickers = {
          find_files = { hidden = true },
        },
      }
    end,
    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)
      pcall(telescope.load_extension, "fzf")
    end,
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>",             desc = "Find files" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>",              desc = "Live grep" },
      { "<leader>fG", "<cmd>Telescope resume<cr>",                 desc = "Resume last picker" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>",                desc = "Buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>",              desc = "Help" },
      { "<leader>fr", "<cmd>Telescope oldfiles<cr>",               desc = "Recent files" },
      { "<leader>fc", "<cmd>Telescope git_commits<cr>",            desc = "Git commits" },
      { "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>",   desc = "Document symbols" },
      { "<leader>fw", "<cmd>Telescope lsp_workspace_symbols<cr>",  desc = "Workspace symbols" },
      { "<leader>fd", "<cmd>Telescope diagnostics<cr>",            desc = "Diagnostics" },
      { "<leader>/",  "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Fuzzy find in buffer" },
      { "<leader>f~", "<cmd>Telescope grep_string<cr>",             desc = "Grep word under cursor", mode = { "n", "v" } },
      { "gf",         "<cmd>Telescope grep_string<cr>",             desc = "Grep word under cursor", mode = { "n", "v" } },
    },
  },
}
