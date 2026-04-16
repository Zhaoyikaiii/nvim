-- Theme configuration for Neovim
local theme_file = vim.fn.stdpath("data") .. "/saved_colorscheme"
local function load_saved_theme()
  local ok, lines = pcall(vim.fn.readfile, theme_file)
  if ok and lines and lines[1] and lines[1] ~= "" then
    return lines[1]
  end
  return "tokyonight"
end

return {
  -- Tell LazyVim to use our saved colorscheme
  { "LazyVim/LazyVim", opts = { colorscheme = load_saved_theme() } },
}
