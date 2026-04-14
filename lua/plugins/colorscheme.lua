-- Colorscheme
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
      vim.cmd("colorscheme zaibatsu")
    end,
  },
  -- Override snacks colorscheme picker to persist selection
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        sources = {
          colorschemes = {
            confirm = function(picker, item)
              picker:close()
              if not item then return end
              local name = item.text
              vim.schedule(function()
                vim.cmd("colorscheme " .. name)
                -- Write the chosen colorscheme into colorscheme.lua
                local config_file = vim.fn.stdpath("config") .. "/lua/plugins/colorscheme.lua"
                local lines = vim.fn.readfile(config_file)
                local new_lines = {}
                for _, line in ipairs(lines) do
                  new_lines[#new_lines + 1] = line:gsub(
                    'vim%.cmd%("colorscheme [^"]*"%)',
                    'vim.cmd("colorscheme ' .. name .. '")'
                  )
                end
                vim.fn.writefile(new_lines, config_file)
                vim.notify('Colorscheme "' .. name .. '" saved to config', vim.log.levels.INFO)
              end)
            end,
          },
        },
      },
    },
  },
}
