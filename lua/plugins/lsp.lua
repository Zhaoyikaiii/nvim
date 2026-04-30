-- LSP-related shared configuration
return {
  -- Configure mason.nvim for LSP management
  {
    "mason-org/mason.nvim",
    opts = {
      max_concurrent_installers = 1, -- Limit concurrent installations
    },
  },

  -- Configure telescope for code actions (on-demand instead of always active)
  {
    "nvim-telescope/telescope.nvim",
    opts = {
      pickers = {
        lsp_references = {
          theme = "dropdown",
          previewer = false, -- Disable previewer to save memory
        },
        lsp_definitions = {
          theme = "dropdown",
          previewer = false,
        },
        lsp_implementations = {
          theme = "dropdown",
          previewer = false,
        },
      },
    },
  },

  -- Auto-save configuration to reduce LSP load
  {
    "okuuva/auto-save.nvim",
    opts = {
      trigger_events = { "InsertLeave", "BufLeave" }, -- Less frequent saves
      debounce_delay = 2000, -- Increase debounce to reduce LSP calls
    },
  },
}