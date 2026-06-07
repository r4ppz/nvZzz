local M = {}

function M.setup(dap)
  local mason_path = require("utils.system").mason_package("local-lua-debugger-vscode")

  dap.adapters["local-lua"] = {
    type = "executable",
    command = "node",
    args = { mason_path .. "/extension/extension/debugAdapter.js" },
    enrich_config = function(config, on_config)
      if not config.extensionPath then
        config = vim.deepcopy(config)
        config.extensionPath = mason_path .. "/extension/"
      end
      on_config(config)
    end,
  }

  dap.adapters.nlua = function(callback, config)
    callback({
      type = "server",
      host = config.host or "127.0.0.1",
      port = config.port or 8086,
    })
  end

  dap.configurations.lua = {
    {
      type = "nlua",
      request = "attach",
      name = "Attach to running Neovim instance",
    },
    {
      name = "Debug Current File",
      type = "local-lua",
      request = "launch",
      cwd = "${workspaceFolder}",
      program = {
        lua = "luajit",
        file = "${file}",
      },
      args = {},
      stopOnEntry = false,
    },
  }
end

return M
