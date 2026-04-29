-- Markdown in-buffer preview (also used by avante.nvim as a dependency)
return {
  {
    "epwalsh/obsidian.nvim",
    version = "*",
    lazy = true,
    ft = "markdown",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      workspaces = {
        {
          name = "TheForest",
          path = "/root/workspace/TheForest",
        },
      },
      -- 日记笔记
      daily_notes = {
        folder = "daily",
        date_format = "%Y-%m-%d",
      },
      -- 补全（nvim-cmp）
      completion = {
        nvim_cmp = true,
        min_chars = 2,
      },
      -- 新建笔记时使用标题作为文件名
      note_id_func = function(title)
        if title ~= nil then
          return title:gsub(" ", "-"):lower()
        else
          return tostring(os.time())
        end
      end,
      -- wiki 链接样式
      preferred_link_style = "wiki",
      -- 用 telescope 作选择器
      picker = {
        name = "telescope.nvim",
      },
    },
    keys = {
      { "<leader>on", "<cmd>ObsidianNew<cr>",          desc = "New note" },
      { "<leader>oo", "<cmd>ObsidianOpen<cr>",         desc = "Open in Obsidian app" },
      { "<leader>os", "<cmd>ObsidianSearch<cr>",       desc = "Search notes" },
      { "<leader>oq", "<cmd>ObsidianQuickSwitch<cr>",  desc = "Quick switch note" },
      { "<leader>ob", "<cmd>ObsidianBacklinks<cr>",    desc = "Backlinks" },
      { "<leader>ot", "<cmd>ObsidianTags<cr>",         desc = "Tags" },
      { "<leader>od", "<cmd>ObsidianToday<cr>",        desc = "Today's daily note" },
      { "<leader>ol", "<cmd>ObsidianLink<cr>",         desc = "Link selection",      mode = "v" },
      { "<leader>or", "<cmd>ObsidianRename<cr>",       desc = "Rename note" },
    },
  },
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
