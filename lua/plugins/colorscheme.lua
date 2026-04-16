-- Colorscheme
local theme_file = vim.fn.stdpath("data") .. "/saved_colorscheme"

local function load_saved_theme()
  local ok, lines = pcall(vim.fn.readfile, theme_file)
  if ok and lines and lines[1] and lines[1] ~= "" then
    return lines[1]
  end
  return "tokyonight"
end

local function save_theme(name)
  vim.fn.writefile({ name }, theme_file)
end

return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = "night",
      transparent = false,
      terminal_colors = true,
      styles = {
        comments = { italic = true },
        keywords = { italic = true },
      },
    },
    config = function(_, opts)
      require("tokyonight").setup(opts)
    end,
  },
  -- Override snacks colorscheme picker to persist selection, and add grep keymaps
  {
    "folke/snacks.nvim",
    keys = {
      { "<leader>fg", function() Snacks.picker.grep() end,   desc = "Live Grep" },
      { "<leader>fG", function() Snacks.picker.resume() end, desc = "Resume last picker" },
    },
    opts = {
      picker = {
        sources = {
          colorschemes = {
            confirm = function(picker, item)
              if not item then
                picker:close()
                return
              end
              local name = item.text
              if picker.preview and picker.preview.state then
                picker.preview.state.colorscheme = nil
              end
              picker:close()
              vim.schedule(function()
                vim.cmd("colorscheme " .. name)
                save_theme(name)
                vim.notify('Colorscheme "' .. name .. '" saved', vim.log.levels.INFO)
              end)
            end,
          },
        },
      },
    },
  },
}
