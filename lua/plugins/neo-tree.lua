return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    sources = { "filesystem", "buffers", "git_status", "document_symbols" },
    bind_to_cwd = false,
    filesystem = {
      follow_current_file = {
        enabled = true,
        leave_dirs_open = true,
      },
      use_libuv_file_watcher = true,
    },

    document_symbols = {
      follow_cursor = true,
      client_filters = "first",
      renderers = {
        root = {
          {"indent"},
          {"icon", default = "C" },
          {"name", zindex = 10 },
        },
        symbol = {
          {"indent", with_expanders = true },
          {"kind_icon", default = "?" },
          {"container", content = { {"name", zindex = 10 } } },
        },
      },
    },
  },
}
