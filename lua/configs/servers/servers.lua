local M = {}

M.non_mason_lsp_list = {
  -- "qml-language-server",
}

M.lsp_list = {
  -- FRONTEND
  "html",
  "cssls",
  "jsonls",
  "yamlls",
  -- "markdown_oxide",
  "marksman",
  -- "eslint",
  -- "ts_ls",
  -- "vtsls",
  -- "biome",
  "tsgo",
  "cssmodules_ls",
  "css_variables",
  "emmet_ls",
  "astro",
  "svelte",
  "prismals",
  "intelephense",

  -- BACKEND
  "jdtls",
  "docker_language_server",
  "dockerls",
  "lemminx",
  "postgres_lsp",
  "gopls",

  "qmlls",
  "taplo",
  "lua_ls",
  "pyright",
  "bashls",
  "rust_analyzer",
  "hyprls",
  "clangd",
  -- "asm_lsp",
  "zls",
}

function M.setup(capabilities)
  -- Filetypes fixes
  vim.filetype.add({
    pattern = {
      ["docker%-compose%.ya?ml"] = "yaml.docker-compose",
      ["compose%.ya?ml"] = "yaml.docker.compose",
      [".*gitlab%-ci%.ya?ml"] = "yaml.gitlab",
      [".*values%.ya?ml"] = "yaml.helm-values",
    },

    extension = {
      tmpl = "gotmpl",
      gotmpl = "gotmpl",
      xsl = "xsl",
      mdx = "markdown.mdx",
      qmljs = "qmljs",
    },
  })

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
