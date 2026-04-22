local M = {}

function M.setup(capabilities)
  vim.lsp.config("taplo", {
    capabilities = capabilities,
    root_markers = { ".git", "taplo.toml" },
    settings = {
      evenBetterToml = {
        taplo = {
          configFile = {
            enabled = false,
          },
        },
      },
    },
  })
end

return M
