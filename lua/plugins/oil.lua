-- oil.nvim: edit filesystem as buffer (opened with -)
-- nvim-tree.lua: sidebar file tree (opened with <leader>e)
return {
  {
    "stevearc/oil.nvim",
    lazy = false,
    opts = {
      default_file_explorer = false,
      columns = { "icon", "permissions", "size", "mtime" },
      view_options = {
        show_hidden = true,
      },
      keymaps = {
        ["g?"] = "actions.show_help",
        ["<CR>"] = "actions.select",
        ["-"] = "actions.parent",
        ["_"] = "actions.open_cwd",
        ["`"] = "actions.cd",
        ["gs"] = "actions.change_sort",
        ["gx"] = "actions.open_external",
        ["g."] = "actions.toggle_hidden",
        ["<C-r>"] = "actions.refresh",
      },
      float = { border = "rounded" },
    },
    keys = {
      { "-", "<cmd>Oil<cr>", desc = "Open parent directory (oil)" },
    },
  },

  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    keys = {
      { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Toggle file tree" },
      { "<leader>E", "<cmd>NvimTreeFocus<cr>",  desc = "Focus file tree" },
    },
    config = function()
      require("nvim-tree").setup({
        hijack_netrw = true,
        sync_root_with_cwd = true,
        respect_buf_cwd = true,
        update_focused_file = {
          enable = true,
          update_root = false, -- don't auto-change root on every buf switch
        },
        view = {
          width = 35,
          side = "left",
        },
        renderer = {
          group_empty = true,
          highlight_git = true,
          icons = {
            show = {
              git = true,
              file = true,
              folder = true,
            },
          },
        },
        filters = {
          dotfiles = false,
          custom = { "^.git$" },
        },
        git = {
          enable = true,
          ignore = false,
        },
        actions = {
          open_file = {
            quit_on_open = false,
            window_picker = { enable = true },
          },
        },
      })

      -- Only update nvim-tree root when the new file belongs to a different git repo
      vim.api.nvim_create_autocmd("BufEnter", {
        callback = function()
          local buf = vim.api.nvim_get_current_buf()
          local ft = vim.bo[buf].filetype
          -- Skip special buffers
          if ft == "NvimTree" or ft == "" or vim.bo[buf].buftype ~= "" then
            return
          end
          local path = vim.api.nvim_buf_get_name(buf)
          if path == "" then return end

          -- Find git root of the current file
          local git_root = vim.fn.systemlist("git -C " .. vim.fn.shellescape(vim.fn.fnamemodify(path, ":h")) .. " rev-parse --show-toplevel")[1]
          if vim.v.shell_error ~= 0 or not git_root then return end

          -- Only change tree root if it differs from current root
          local api = require("nvim-tree.api")
          local current_root = api.tree.get_nodes() and vim.fn.fnamemodify(api.tree.get_nodes().absolute_path, ":h:h") or ""
          if git_root ~= current_root then
            api.tree.change_root(git_root)
          end
        end,
      })
    end,
  },
}
