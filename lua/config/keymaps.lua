-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Neotest keymaps
vim.keymap.set('n', '<leader>tt', function() require('neotest').run.run() end, { desc = 'Run nearest test' })
vim.keymap.set('n', '<leader>tf', function() require('neotest').run.run(vim.fn.expand('%')) end, { desc = 'Run current file tests' })
vim.keymap.set('n', '<leader>ts', function() require('neotest').summary.open() end, { desc = 'Open test summary' })
vim.keymap.set('n', '<leader>to', function() require('neotest').output.open({ enter = true }) end, { desc = 'Open test output' })
vim.keymap.set('n', '<leader>tO', function() require('neotest').output_panel.toggle() end, { desc = 'Toggle test output panel' })
vim.keymap.set('n', '<leader>tS', function() require('neotest').run.stop() end, { desc = 'Stop running test' })

-- Coverage keymaps
vim.keymap.set('n', '<leader>tc', ':Coverage<CR>', { desc = 'Show coverage' })
vim.keymap.set('n', '<leader>tC', ':CoverageToggle<CR>', { desc = 'Toggle coverage' })
vim.keymap.set('n', '<leader>tL', ':CoverageLoad<CR>', { desc = 'Load coverage' })
vim.keymap.set('n', '<leader>tX', ':CoverageClear<CR>', { desc = 'Clear coverage' })
