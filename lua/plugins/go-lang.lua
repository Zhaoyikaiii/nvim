return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        gopls = {
          settings = {
            gopls = {
              ui = {
                semanticTokens = true,
              },
              gofumpt = true,
              analyses = {
                unusedparams = true,
                shadow = true,
                unusedwrite = true,
                useany = true,
              },
              -- Test support configuration
              codelenses = {
                generate = true,
                gc_details = true,
                test = true,
                tidy = true,
                upgrade_dependency = true,
                regenerate_cgo = true,
              },
              -- Enable test diagnostics
              diagnosticsDelay = "500ms",
              staticcheck = true,
              -- Improved test completion
              usePlaceholders = true,
              completeUnimported = true,
              deepCompletion = true,
            },
          },
        },
      },
    },
  },
}
