-- blink.cmp: completion engine + LuaSnip + friendly-snippets
return {
  {
    "L3MON4D3/LuaSnip",
    build = (function()
      if vim.fn.executable("make") == 1 then
        return "make install_jsregexp"
      end
    end)(),
    dependencies = {
      "rafamadriz/friendly-snippets",
      config = function()
        require("luasnip.loaders.from_vscode").lazy_load()
      end,
    },
    opts = {
      history = true,
      delete_check_events = "TextChanged",
    },
  },

  {
    "saghen/blink.cmp",
    version = "*",
    event = "InsertEnter",
    dependencies = {
      "L3MON4D3/LuaSnip",
      "rafamadriz/friendly-snippets",
    },
    opts = {
      keymap = {
        preset = "default",
        ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
        ["<C-e>"]     = { "hide" },
        ["<CR>"]      = { "accept", "fallback" },
        ["<Tab>"]     = { "snippet_forward", "fallback" },
        ["<S-Tab>"]   = { "snippet_backward", "fallback" },
        ["<C-j>"]     = { "select_next", "fallback" },
        ["<C-k>"]     = { "select_prev", "fallback" },
        ["<C-d>"]     = { "scroll_documentation_down", "fallback" },
        ["<C-u>"]     = { "scroll_documentation_up", "fallback" },
      },
      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = "mono",
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
        providers = {
          lsp = { score_offset = 5 },
          snippets = {
            opts = {
              friendly_snippets = true,
              search_paths = { vim.fn.stdpath("data") .. "/lazy/friendly-snippets" },
            },
          },
        },
      },
      snippets = {
        expand = function(snippet)
          require("luasnip").lsp_expand(snippet)
        end,
        active = function(filter)
          if filter and filter.direction then
            return require("luasnip").jumpable(filter.direction)
          end
          return require("luasnip").in_snippet()
        end,
        jump = function(direction)
          require("luasnip").jump(direction)
        end,
      },
      signature = { enabled = true },
      completion = {
        accept = { auto_brackets = { enabled = true } },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
          window = { border = "rounded" },
        },
        menu = { border = "rounded" },
      },
    },
  },
}
