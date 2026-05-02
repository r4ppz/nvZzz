local M = {}

M.server_list = {
  -- FRONTEND
  "html",
  "cssls",
  "jsonls",
  "yamlls",
  -- "markdown_oxide",
  "marksman",
  "eslint",
  -- "ts_ls",
  -- "vtsls",
  -- "biome",
  -- "tsgo",
  "cssmodules_ls",
  "css_variables",
  -- "emmet_ls",
  "astro",
  "svelte",
  "prismals",

  -- BACKEND
  "jdtls",
  "docker_language_server",
  "dockerls",
  "lemminx",
  "postgres_lsp",
  "gopls",

  "taplo",
  "lua_ls",
  "pyright",
  "bashls",
  "rust_analyzer",
  "hyprls",
  "clangd",
  "asm_lsp",
}

function M.setup(capabilities)
  local config_dir = vim.fn.stdpath("config") .. "/lua/configs/servers"
  if vim.fn.isdirectory(config_dir) ~= 1 then
    return
  end

  local files = vim.fn.readdir(config_dir)
  for _, f in ipairs(files) do
    if f:match("%.lua$") and f ~= "servers.lua" then
      local modname = f:gsub("%.lua$", "")
      local mod = require("configs.servers." .. modname)
      mod.setup(capabilities)
    end
  end
end

return M
