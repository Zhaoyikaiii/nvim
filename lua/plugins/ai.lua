-- AI: avante.nvim (Cursor-like AI coding assistant)
return {
  -- Image paste support (optional, used by avante)
  {
    "HakonHarnes/img-clip.nvim",
    event = "VeryLazy",
    opts = {
      default = {
        embed_image_as_base64 = false,
        prompt_for_file_name = false,
        drag_and_drop = {
          insert_mode = true,
        },
        use_absolute_path = true,
        verbose = false, -- suppress "Content is not an image" warning triggered by CJK IME input
      },
    },
  },

  -- Avante: Cursor-like AI assistant
  {
    "yetone/avante.nvim",
    build = "make",
    event = "VeryLazy",
    version = false,
    opts = {
      provider = "kimi",
      providers = {
        kimi = {
          __inherited_from = "openai",
          endpoint = "https://api.moonshot.ai/v1",
          model = "kimi-latest",
          api_key_name = "MOONSHOT_API_KEY",
          extra_request_body = {
            temperature = 0.75,
            max_tokens = 8192,
          },
        },
      },
      behaviour = {
        auto_suggestions = false,
        auto_set_highlight_group = true,
        auto_set_keymaps = true,
        auto_apply_diff_after_generation = false,
        support_paste_from_clipboard = false,
        minimize_diff = true,
        enable_token_counting = true,
      },
      windows = {
        position = "right",
        wrap = true,
        width = 35,
        sidebar_header = {
          enabled = true,
          align = "center",
          rounded = true,
        },
      },
      mappings = {
        diff = {
          ours = "co",
          theirs = "ct",
          all_theirs = "ca",
          both = "cb",
          cursor = "cc",
          next = "]x",
          prev = "[x",
        },
        suggestion = {
          accept = "<M-l>",
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-]>",
        },
        submit = {
          normal = "<CR>",
          insert = "<C-s>",
        },
        ask = "<leader>aa",
        edit = "<leader>ae",
        refresh = "<leader>ar",
        focus = "<leader>af",
        toggle = {
          default = "<leader>at",
          debug = "<leader>ad",
          hint = "<leader>ah",
          suggestion = "<leader>as",
          repomap = "<leader>aR",
        },
        sidebar = {
          apply_all = "A",
          apply_cursor = "a",
          switch_windows = "<Tab>",
          reverse_switch_windows = "<S-Tab>",
        },
      },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-tree/nvim-web-devicons",
      "folke/snacks.nvim",
      "MeanderingProgrammer/render-markdown.nvim",
      "HakonHarnes/img-clip.nvim",
    },
  },
}
