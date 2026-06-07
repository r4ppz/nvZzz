local M = {}

M.dap_list = {
  -- "local-lua-debugger-vscode",
  "delve",
}

function M.setup()
  local config_dir = vim.fn.stdpath("config") .. "/lua/configs/debuggers"
  if vim.fn.isdirectory(config_dir) ~= 1 then
    return
  end

  local files = vim.fn.readdir(config_dir)
  for _, f in ipairs(files) do
    if f:match("%.lua$") and f ~= "debuggers.lua" then
      local modname = f:gsub("%.lua$", "")
      local mod = require("configs.debuggers." .. modname)
      mod.setup(require("dap"))
    end
  end
end

return M
