-- Memory management utilities for Neovim
local M = {}

-- Configuration
M.config = {
  max_memory_mb = 512, -- 512MB limit
  check_interval = 15000, -- 15 seconds
  cleanup_threshold = 0.6, -- 60% of max memory (more aggressive)
}

-- Get current memory usage in MB
local function get_memory_usage()
  -- Try different methods based on the platform
  local memory_bytes = 0

  -- Method 1: Try using ps command (Linux/macOS)
  local handle = io.popen('ps -o rss= -p ' .. vim.fn.getpid())
  if handle then
    local result = handle:read("*a")
    handle:close()
    memory_bytes = tonumber(result) or 0
    if memory_bytes > 0 then
      return memory_bytes / 1024 -- Convert KB to MB
    end
  end

  -- Method 2: Fallback to a simple estimation
  -- Use collectgarbage("count") which returns memory in KB
  local gc_memory = collectgarbage("count") or 0
  return gc_memory / 1024 -- Convert KB to MB
end

-- Cleanup functions
local function cleanup_buffers()
  local buffers = vim.api.nvim_list_bufs()
  local to_delete = {}

  for _, buf in ipairs(buffers) do
    if not vim.api.nvim_buf_is_loaded(buf) then
      table.insert(to_delete, buf)
    end
  end

  for _, buf in ipairs(to_delete) do
    vim.api.nvim_buf_delete(buf, { force = true })
  end

  if #to_delete > 0 then
    print("Cleaned up " .. #to_delete .. " unused buffers")
  end
end

local function cleanup_jumplist()
  vim.fn.setpos(".", vim.fn.getpos("."))
  vim.cmd("clearjumps")
end

local function cleanup_registers()
  -- Clear registers except special ones
  local keep_registers = { '"', "_", "*", "+", ".", "/", "-", ":", "%", "#", "=", "@" }
  for i = 65, 90 do -- Only clear uppercase letter registers (A-Z)
    local reg = string.char(i)
    if not vim.tbl_contains(keep_registers, reg) then
      pcall(vim.fn.setreg, reg, "")
    end
  end
  -- Clear number registers 0-9
  for i = 48, 57 do
    local reg = string.char(i)
    pcall(vim.fn.setreg, reg, "")
  end
end

local function cleanup_search()
  vim.cmd("nohlsearch")
  vim.fn.setreg("/", "")
end

local function cleanup_undo()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) then
      vim.bo[buf].undolevels = -1
      vim.bo[buf].undolevels = 1000
    end
  end
end

local function stop_inactive_lsp_clients()
  local lsp_clients = vim.lsp.get_active_clients()
  local current_buf = vim.api.nvim_get_current_buf()
  local current_ft = vim.bo[current_buf].filetype

  for _, client in ipairs(lsp_clients) do
    local attached_buffers = vim.lsp.get_buffers_by_client_id(client.id)
    local should_stop = true

    -- More aggressive stopping: only keep rust-analyzer for rust files
    if client.name == "rust_analyzer" and current_ft == "rust" then
      should_stop = false
    end

    -- Always stop non-essential LSP clients
    if vim.tbl_contains({ "null-ls", "lua_ls", "html", "cssls", "tsserver" }, client.name) then
      should_stop = true
    end

    if should_stop then
      client.stop()
      print("Stopped LSP client: " .. client.name)
    end
  end
end

-- Main cleanup function
function M.cleanup()
  print("Starting memory cleanup...")

  cleanup_buffers()
  cleanup_jumplist()
  cleanup_registers()
  cleanup_search()
  cleanup_undo()
  stop_inactive_lsp_clients()

  -- Collect garbage
  collectgarbage("collect")

  local memory_after = get_memory_usage()
  print("Cleanup complete. Current memory usage: " .. string.format("%.0f", memory_after) .. "MB")
end

-- Memory monitoring
local function check_memory()
  local current_memory = get_memory_usage()

  if current_memory > M.config.max_memory_mb * M.config.cleanup_threshold then
    print("High memory usage detected: " .. string.format("%.0f", current_memory) .. "MB")
    M.cleanup()
  end
end

-- Start memory monitoring
function M.start_monitoring()
  local timer = vim.loop.new_timer()
  timer:start(0, M.config.check_interval, function()
    vim.schedule(function()
      check_memory()
    end)
  end)

  print("Memory monitoring started (checking every " .. (M.config.check_interval / 1000) .. "s)")
  return timer
end

-- Setup function
function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", M.config, opts or {})

  -- Create autocmds
  local group = vim.api.nvim_create_augroup("MemoryManager", { clear = true })

  -- Cleanup on certain events
  vim.api.nvim_create_autocmd({ "VimLeavePre" }, {
    group = group,
    callback = M.cleanup,
  })

  vim.api.nvim_create_autocmd({ "BufWinLeave" }, {
    group = group,
    callback = function()
      if vim.fn.len(vim.fn.getbufinfo({ buflisted = 1 })) > 10 then
        cleanup_buffers()
      end
    end,
  })

  -- Start monitoring
  M.start_monitoring()

  -- Create commands
  vim.api.nvim_create_user_command("MemoryCleanup", M.cleanup, {})
  vim.api.nvim_create_user_command("MemoryStatus", function()
    local memory = get_memory_usage()
    print("Current memory usage: " .. string.format("%.0f", memory) .. "MB")
  end, {})

  -- Create keymaps
  vim.keymap.set("n", "<leader>mc", M.cleanup, { desc = "Memory Cleanup" })
  vim.keymap.set("n", "<leader>ms", function()
    local memory = get_memory_usage()
    print("Current memory usage: " .. string.format("%.0f", memory) .. "MB")
  end, { desc = "Memory Status" })
end

return M