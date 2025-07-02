-- lua/custom/dap.lua
local dap = require("dap")

dap.adapters.go = {
  type = "server",
  port = "${port}",
  executable = {
    command = "dlv",
    args = { "dap", "-l", "127.0.0.1:${port}" },
  },
}

dap.configurations.go = {
  {
    type = "go",
    name = "Debug",
    request = "launch",
    program = "${fileDirname}",
  },
  {
    type = "go",
    name = "Debug test", -- configuration for debugging tests
    request = "launch",
    mode = "test",
    program = "${fileDirname}",
  },
}
