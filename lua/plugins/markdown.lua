-- Markdown in-buffer preview (also used by avante.nvim as a dependency)
return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "Avante" },
    opts = {
      file_types = { "markdown", "Avante" },
      heading = { width = "block" },
      code = { width = "block", left_pad = 2, right_pad = 2 },
      checkbox = { enabled = true },
    },
    keys = {
      { "<leader>mp", "<cmd>RenderMarkdown toggle<cr>", desc = "Toggle markdown preview (render-markdown)" },
    },
  },
}
