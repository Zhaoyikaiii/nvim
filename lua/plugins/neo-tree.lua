return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    filesystem = {
      follow_current_file = {
        enabled = true,
        leave_dirs_open = true,
      },
      use_libuv_file_watcher = true,
    },
  },
  config = function(_, opts)
    require("neo-tree").setup(opts)

    vim.api.nvim_create_autocmd("BufEnter", {
      group = vim.api.nvim_create_augroup("NeoTreeForceReveal", { clear = true }),
      callback = function()
        local current_file = vim.fn.expand("%:p")
        if vim.fn.filereadable(current_file) == 1 then
          vim.schedule(function()
            require("neo-tree.command").execute({
              action = "show",
              reveal = true,
              reveal_force_cwd = false
            })
          end)
        end
      end,
    })
  end,
}
