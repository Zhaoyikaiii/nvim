-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- Initialize memory manager for rust-analyzer optimization
require("config.memory-manager").setup({
  max_memory_mb = 512, -- Limit to 512MB
  check_interval = 15000, -- Check every 15 seconds
  cleanup_threshold = 0.7, -- Clean at 70% usage
})
