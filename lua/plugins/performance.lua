-- Global performance and memory optimizations
return {
  -- Configure bufferline with memory optimizations
  {
    "akinsho/bufferline.nvim",
    opts = {
      options = {
        max_name_length = 14,
        max_prefix_length = 13,
        truncate_names = true,
        tab_size = 20,
        diagnostics = false, -- Disable diagnostics in bufferline
        show_buffer_icons = false, -- Disable icons
        show_buffer_close_icons = false,
        show_close_icon = false,
        show_tab_indicators = false,
        separator_style = "slant",
        enforce_regular_tabs = false,
        always_show_bufferline = false, -- Hide when only one buffer
      },
    },
  },
}