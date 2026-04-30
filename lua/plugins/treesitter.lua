-- Treesitter (nvim-treesitter v1 compatible)
-- highlight/indent are driven by native vim.treesitter.
-- nvim-treesitter only installs parsers and provides indentexpr.
-- nvim-treesitter-textobjects v2 uses direct function calls for keymaps.
return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    config = function()
      -- Enable native treesitter highlight + nvim-treesitter indent per filetype
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(ev)
          local ok = pcall(vim.treesitter.start, ev.buf)
          if ok then
            vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })

      -- Install parsers
      require("nvim-treesitter.install").install({
        "lua", "luadoc",
        "go", "gomod", "gosum", "gowork",
        "rust",
        "python",
        "typescript", "javascript", "tsx", "json",
        "html", "css",
        "bash",
        "yaml", "toml",
        "markdown", "markdown_inline",
        "vim", "vimdoc",
        "diff", "gitcommit",
        "regex",
      })
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    lazy = true,
    config = function()
      local select = require("nvim-treesitter-textobjects.select")
      local move   = require("nvim-treesitter-textobjects.move")

      -- Text object select keymaps
      local select_maps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
        ["aa"] = "@parameter.outer",
        ["ia"] = "@parameter.inner",
      }
      for key, query in pairs(select_maps) do
        vim.keymap.set({ "x", "o" }, key, function()
          select.select_textobject(query, "textobjects")
        end, { desc = "TS select " .. query })
      end

      -- Move keymaps
      local move_maps = {
        { "]f", "goto_next_start",     "@function.outer" },
        { "]c", "goto_next_start",     "@class.outer"    },
        { "]F", "goto_next_end",       "@function.outer" },
        { "]C", "goto_next_end",       "@class.outer"    },
        { "[f", "goto_previous_start", "@function.outer" },
        { "[c", "goto_previous_start", "@class.outer"    },
        { "[F", "goto_previous_end",   "@function.outer" },
        { "[C", "goto_previous_end",   "@class.outer"    },
      }
      for _, m in ipairs(move_maps) do
        local key, fn, query = m[1], m[2], m[3]
        vim.keymap.set("n", key, function()
          move[fn](query, "textobjects")
        end, { desc = "TS " .. fn .. " " .. query })
      end
    end,
  },
}
