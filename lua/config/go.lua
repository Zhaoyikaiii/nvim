-- Go specific configurations and utilities
local M = {}

-- Go keymaps
function M.setup_keymaps()
  -- Go run
  vim.keymap.set("n", "<leader>gr", "<cmd>GoRun<CR>", { desc = "Go Run" })

  -- Go build
  vim.keymap.set("n", "<leader>gb", "<cmd>GoBuild<CR>", { desc = "Go Build" })

  -- Go test
  vim.keymap.set("n", "<leader>gt", "<cmd>GoTest<CR>", { desc = "Go Test" })

  -- Go test file
  vim.keymap.set("n", "<leader>gT", "<cmd>GoTestFile<CR>", { desc = "Go Test File" })

  -- Go test function
  vim.keymap.set("n", "<leader>gf", "<cmd>GoTestFunc<CR>", { desc = "Go Test Function" })

  -- Go coverage
  vim.keymap.set("n", "<leader>gc", "<cmd>GoCoverage<CR>", { desc = "Go Coverage" })

  -- Go coverage browser
  vim.keymap.set("n", "<leader>gC", "<cmd>GoCoverageBrowser<CR>", { desc = "Go Coverage Browser" })

  -- Go alternate file (test <-> source)
  vim.keymap.set("n", "<leader>ga", "<cmd>GoAlternate<CR>", { desc = "Go Alternate File" })

  -- Go impl
  vim.keymap.set("n", "<leader>gi", "<cmd>GoImpl<CR>", { desc = "Go Implement Interface" })

  -- Go fill struct
  vim.keymap.set("n", "<leader>gs", "<cmd>GoFillStruct<CR>", { desc = "Go Fill Struct" })

  -- Go fill switch
  vim.keymap.set("n", "<leader>gS", "<cmd>GoFillSwitch<CR>", { desc = "Go Fill Switch" })

  -- Go tags add
  vim.keymap.set("n", "<leader>gta", "<cmd>GoTagAdd<CR>", { desc = "Go Add Tags" })

  -- Go tags remove
  vim.keymap.set("n", "<leader>gtr", "<cmd>GoTagRm<CR>", { desc = "Go Remove Tags" })

  -- Go doc
  vim.keymap.set("n", "K", "<cmd>GoDoc<CR>", { desc = "Go Documentation", buffer = true })

  -- Go doc under cursor
  vim.keymap.set("n", "<leader>gd", "<cmd>GoDocBrowser<CR>", { desc = "Go Documentation Browser" })

  -- Go to documentation
  vim.keymap.set("n", "<leader>gg", "<cmd>GoModTidy<CR>", { desc = "Go Mod Tidy" })

  -- Go mod vendor
  vim.keymap.set("n", "<leader>gv", "<cmd>GoModVendor<CR>", { desc = "Go Mod Vendor" })

  -- Go update dependencies
  vim.keymap.set("n", "<leader>gu", "<cmd>GoModUpgrade<CR>", { desc = "Go Mod Upgrade" })

  -- Go clean
  vim.keymap.set("n", "<leader>gcl", "<cmd>GoClean<CR>", { desc = "Go Clean" })

  -- Generate interface
  vim.keymap.set("n", "<leader>ge", "<cmd>GoGenReturn<CR>", { desc = "Go Generate Return" })
end

-- Go status line
function M.setup_statusline()
  local function go_status()
    local status = ""

    -- Check if we're in a Go project
    if vim.fn.filereadable("go.mod") == 1 then
      status = "🐹 Go"

      -- Add build status
      local buildable = vim.fn.executable("go") == 1
      if buildable then
        status = status .. " ✓"
      else
        status = status .. " ✗"
      end
    end

    return status
  end

  -- You can integrate this with your status line plugin
  return go_status
end

-- Auto-commands for Go files
function M.setup_autocmds()
  local group = vim.api.nvim_create_augroup("GoConfig", { clear = true })

  -- Auto organize imports on save
  vim.api.nvim_create_autocmd("BufWritePre", {
    group = group,
    pattern = "*.go",
    callback = function()
      vim.lsp.buf.format({ async = false })
    end,
  })

  -- Set up Go-specific options
  vim.api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = "go",
    callback = function()
      -- Local options for Go files
      vim.opt_local.tabstop = 4
      vim.opt_local.shiftwidth = 4
      vim.opt_local.expandtab = true
      vim.opt_local.softtabstop = 4

      -- Go-specific highlighting
      vim.cmd([[highlight goComment ctermfg=green guifg=green]])
    end,
  })

  -- Auto create test files if they don't exist
  vim.api.nvim_create_autocmd("BufNewFile", {
    group = group,
    pattern = "*_test.go",
    callback = function()
      local content = [[
package %s

import (
	"testing"
)

func Test%s(t *testing.T) {
	t.Run("", func(t *testing.T) {
		// Test implementation
	})
}
]]
      local package_name = vim.fn.expand("%:p:h:t")
      local func_name = vim.fn.expand("%:t:r"):gsub("_test$", "")

      local new_content = string.format(content, package_name, func_name)
      vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(new_content, "\n"))
    end,
  })
end

-- Project management utilities
function M.setup_project_utils()
  -- Quick project creation
  vim.api.nvim_create_user_command("GoNewProject", function(opts)
    local project_name = opts.args
    if project_name == "" then
      project_name = vim.fn.input("Project name: ")
    end

    local cmd = string.format("mkdir -p %s && cd %s && go mod init %s",
      project_name, project_name, project_name)
    vim.fn.system(cmd)
    vim.cmd("e " .. project_name .. "/main.go")
  end, { nargs = "?", complete = "file" })

  -- Run benchmarks
  vim.api.nvim_create_user_command("GoBench", function()
    vim.cmd("term go test -bench=.")
  end, {})

  -- Profile
  vim.api.nvim_create_user_command("GoProfile", function()
    vim.cmd("term go test -cpuprofile=cpu.prof -memprofile=mem.prof -bench=.")
  end, {})

  -- Race condition detection
  vim.api.nvim_create_user_command("GoRace", function()
    vim.cmd("term go test -race ./...")
  end, {})
end

-- Project templates
function M.setup_templates()
  local templates = require("config.go-templates")

  -- Create web service project
  vim.api.nvim_create_user_command("GoWebProject", function(opts)
    local project_name = opts.args
    if project_name == "" then
      project_name = vim.fn.input("Web service project name: ")
    end

    -- Create project structure
    vim.fn.system(string.format("mkdir -p %s/{cmd,internal/{handler,service,repository},pkg,config}", project_name))

    -- Create main.go
    local main_content = string.format(templates.web_service, project_name)
    vim.fn.writefile(vim.split(main_content, "\n"), project_name .. "/main.go")

    -- Create go.mod
    vim.fn.system(string.format("cd %s && go mod init %s", project_name, project_name))
    vim.fn.system(string.format("cd %s && go get -u github.com/gin-gonic/gin", project_name))

    -- Create Dockerfile
    vim.fn.writefile(vim.split(templates.dockerfile, "\n"), project_name .. "/Dockerfile")

    -- Create Makefile
    local makefile_content = string.format(templates.makefile, project_name)
    vim.fn.writefile(vim.split(makefile_content, "\n"), project_name .. "/Makefile")

    -- Create .gitignore
    vim.fn.writefile(vim.split(templates.gitignore, "\n"), project_name .. "/.gitignore")

    print("Web service project created: " .. project_name)
    vim.cmd("cd " .. project_name)
    vim.cmd("edit main.go")
  end, { nargs = "?", complete = "file" })

  -- Create library project
  vim.api.nvim_create_user_command("GoLibProject", function(opts)
    local project_name = opts.args
    if project_name == "" then
      project_name = vim.fn.input("Library project name: ")
    end

    -- Create project structure
    vim.fn.system(string.format("mkdir -p %s/{pkg,cmd,internal,examples}", project_name))

    -- Create main library file
    local lib_content = string.format(templates.library, project_name, project_name, project_name, project_name, project_name, project_name, project_name, project_name, project_name)
    vim.fn.writefile(vim.split(lib_content, "\n"), project_name .. "/pkg/" .. project_name .. ".go")

    -- Create test file
    local test_content = string.format(templates.test_template, project_name, project_name, project_name)
    vim.fn.writefile(vim.split(test_content, "\n"), project_name .. "/pkg/" .. project_name .. "_test.go")

    -- Create example
    local example_content = string.format(templates.cli_app, project_name)
    vim.fn.writefile(vim.split(example_content, "\n"), project_name .. "/cmd/example/main.go")

    -- Initialize go.mod
    vim.fn.system(string.format("cd %s && go mod init %s", project_name, project_name))

    -- Create .gitignore
    vim.fn.writefile(vim.split(templates.gitignore, "\n"), project_name .. "/.gitignore")

    print("Library project created: " .. project_name)
    vim.cmd("cd " .. project_name)
    vim.cmd("edit pkg/" .. project_name .. ".go")
  end, { nargs = "?", complete = "file" })

  -- Create CLI project
  vim.api.nvim_create_user_command("GoCLIProject", function(opts)
    local project_name = opts.args
    if project_name == "" then
      project_name = vim.fn.input("CLI project name: ")
    end

    -- Create project structure
    vim.fn.system(string.format("mkdir -p %s/{cmd,internal/{cli,config},pkg}", project_name))

    -- Create main CLI file
    local cli_content = string.format(templates.cli_app, project_name)
    vim.fn.writefile(vim.split(cli_content, "\n"), project_name .. "/cmd/" .. project_name .. "/main.go")

    -- Initialize go.mod
    vim.fn.system(string.format("cd %s && go mod init %s", project_name, project_name))

    -- Create .gitignore
    vim.fn.writefile(vim.split(templates.gitignore, "\n"), project_name .. "/.gitignore")

    print("CLI project created: " .. project_name)
    vim.cmd("cd " .. project_name)
    vim.cmd("edit cmd/" .. project_name .. "/main.go")
  end, { nargs = "?", complete = "file" })
end

-- Completion utilities
function M.setup_completion()
  -- Go-specific completion snippets
  local cmp = require("cmp")

  if cmp then
    cmp.setup.filetype("go", {
      sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "buffer" },
        { name = "path" },
      }),
    })
  end
end

-- Setup all configurations
function M.setup()
  M.setup_keymaps()
  M.setup_autocmds()
  M.setup_project_utils()
  M.setup_templates()
  M.setup_completion()
end

return M