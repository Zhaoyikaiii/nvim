-- Global performance and memory optimizations
return {
  -- Configure nvim-cmp with memory optimizations
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      -- Reduce completion performance overhead
      opts.performance = {
        debounce = 150, -- Increase debounce
        throttle = 60,  -- Increase throttle
        fetching_timeout = 500,
        confirm_resolve_timeout = 80,
        async_timeout = 1000,
        max_view_entries = 20, -- Limit visible entries
      }

      -- Disable some completion sources for memory
      local cmp = require("cmp")
      opts.sources = cmp.config.sources({
        { name = "nvim_lsp", priority = 1000 },
        { name = "path", priority = 500 },
        -- Disable heavy sources
        -- { name = "buffer", priority = 250 },
        -- { name = "calc", priority = 100 },
      })

      -- Configure snippet engine
      opts.snippet = {
        expand = function(args)
          require("luasnip").lsp_expand(args.body)
        end,
      }

      -- Limit completion items
      opts.window = {
        completion = {
          border = "rounded",
          winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
        },
        documentation = {
          border = "rounded",
          winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
        },
      }
    end,
  },

  -- Configure treesitter with memory optimizations
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      highlight = {
        enable = true,
        disable = function(lang, bufnr)
          -- Disable for large files
          local line_count = vim.api.nvim_buf_line_count(bufnr)
          if line_count > 10000 then
            return true
          end
          -- Disable for specific languages that are memory intensive
          local disable_langs = { "typescript", "javascript", "vue", "svelte" }
          return vim.tbl_contains(disable_langs, lang)
        end,
        additional_vim_regex_highlighting = false, -- Disable regex highlighting
      },
      incremental_selection = {
        enable = false, -- Disable incremental selection
      },
      indent = {
        enable = false, -- Disable treesitter indent
      },
      autotag = {
        enable = false, -- Disable autotag
      },
      textobjects = {
        enable = false, -- Disable text objects
      },
      ensure_installed = {
        "lua",
        "rust",
        "toml",
        "bash",
        "markdown",
        "markdown_inline",
      },
      sync_install = false, -- Don't sync install
      auto_install = false, -- Don't auto install
    },
  },

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

  -- Configure lualine with minimal components
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "filename" },
        lualine_c = {}, -- Empty
        lualine_x = { "encoding", "fileformat" },
        lualine_y = { "filetype" },
        lualine_z = { "location" },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = { "filename" },
        lualine_c = {},
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
      },
      extensions = {},
    },
  },

  -- Configure telescope with performance optimizations
  {
    "nvim-telescope/telescope.nvim",
    opts = {
      defaults = {
        layout_strategy = "vertical",
        layout_config = {
          width = 0.8,
          height = 0.8,
          preview_cutoff = 120,
        },
        path_display = { "truncate" },
        file_ignore_patterns = {
          "node_modules",
          ".git",
          "target",
          "dist",
          "build",
          "%.class",
          "%.o",
          "%.dll",
          "%.exe",
        },
        disable_devicons = false, -- Keep icons but could disable for more savings
        vimgrep_arguments = {
          "rg",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
          "--max-columns=200",
          "--max-depth=4",
        },
      },
      pickers = {
        find_files = {
          hidden = false,
          no_ignore = false,
          follow = false,
        },
        live_grep = {
          additional_args = function()
            return { "--max-depth=4" }
          end,
        },
      },
    },
  },

  -- Configure autopairs with performance optimizations
  {
    "windwp/nvim-autopairs",
    opts = {
      disable_filetype = { "TelescopePrompt", "spectre_panel" },
      disable_in_macro = false,
      disable_in_visualblock = false,
      disable_in_replace_mode = true,
      ignored_next_char = [=[[%w%%%'%[%"%.%`%$]]=],
      enable_moveright = true,
      enable_afterquote = true,
      check_ts = false, -- Disable treesitter check
      map_bs = true,
      map_c_h = false,
      map_c_w = false,
    },
  },

  -- Configure gitsigns with minimal features
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      signs = {
        add = { text = "│" },
        change = { text = "│" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
      current_line_blame = false, -- Disable blame
      signcolumn = true,
      numhl = false, -- Disable number highlight
      linehl = false, -- Disable line highlight
      word_diff = false, -- Disable word diff
      watch_gitdir = {
        interval = 1000, -- Increase interval
      },
      attach_to_untracked = false,
      debug_mode = false,
    },
  },

  -- Configure indent-blankline with performance optimizations (v3)
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {
      indent = {
        char = "│",
      },
      scope = {
        enabled = false,
        show_start = false,
        show_end = false,
      },
      exclude = {
        filetypes = {
          "help",
          "alpha",
          "dashboard",
          "neo-tree",
          "Trouble",
          "lazy",
          "mason",
          "notify",
          "toggleterm",
          "lazyterm",
          "terminal",
          "nofile",
          "quickfix",
          "prompt",
        },
      },
    },
  },
}