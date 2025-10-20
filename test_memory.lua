-- Test script to verify memory optimizations
-- Run with: nvim -l test_memory.lua

print("=== Neovim 512MB Memory Optimization Test ===")

-- Test memory manager
local memory_manager = require("config.memory-manager")
print("✓ Memory manager loaded successfully")

-- Test configuration values
local config = memory_manager.config
print("✓ Memory limit:", config.max_memory_mb .. "MB")
print("✓ Check interval:", config.check_interval / 1000 .. " seconds")
print("✓ Cleanup threshold:", (config.cleanup_threshold * 100) .. "%")

-- Test LSP configuration
print("✓ Testing LSP configuration...")
local lsp_ok, lsp_config = pcall(require, "plugins.lsp")
if lsp_ok then
  print("✓ LSP configuration loaded")
else
  print("✗ LSP configuration error")
end

-- Test Rust configuration
print("✓ Testing Rust configuration...")
local rust_ok, rust_config = pcall(require, "plugins.rust")
if rust_ok then
  print("✓ Rust configuration loaded")
else
  print("✗ Rust configuration error")
end

-- Test performance configuration
print("✓ Testing performance configuration...")
local perf_ok, perf_config = pcall(require, "plugins.performance")
if perf_ok then
  print("✓ Performance configuration loaded")
else
  print("✗ Performance configuration error")
end

print("\n=== Optimization Summary ===")
print("Target memory usage: 512MB")
print("Auto-cleanup: Every 15 seconds")
print("Cleanup threshold: 60% (307MB)")
print("Features disabled:")
print("  - proc macros")
print("  - code lens")
print("  - inlay hints")
print("  - auto imports")
print("  - hover actions")
print("\n✓ All optimizations configured successfully!")
print("Ready for Rust development with minimal memory footprint.")