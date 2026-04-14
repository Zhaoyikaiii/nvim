-- ruff LSP config (lint + organize imports, NOT format — format goes to conform)
return {
  -- Disable hover in favour of basedpyright
  on_attach = function(client, _)
    client.server_capabilities.hoverProvider = false
  end,
  init_options = {
    settings = {
      lint = { enable = true },
      organizeImports = true,
    },
  },
}
