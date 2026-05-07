local M = {}

function M.setup(capabilities)
  vim.lsp.config("docker_compose_language_service", {
    capabilities = capabilities,
    root_markers = {
      "docker-compose.yaml",
      "docker-compose.yml",
      "compose.yaml",
      "compose.yml",
    },
    filetypes = { "yml" },
  })

  vim.lsp.config("dockerls", {
    capabilities = capabilities,
    root_markers = {
      "docker-compose.yaml",
      "docker-compose.yml",
      "compose.yaml",
      "compose.yml",
    },
    filetypes = { "yml" },
  })
end

return M
