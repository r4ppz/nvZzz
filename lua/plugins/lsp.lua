local servers = {
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

return {
  "neovim/nvim-lspconfig",
  event = "FileType",
  dependencies = {
    "antosha417/nvim-lsp-file-operations",
    {
      "mason-org/mason.nvim",
      opts = function()
        return {
          PATH = "skip",
          ui = {
            border = "single",
            icons = {
              package_pending = " ",
              package_installed = " ",
              package_uninstalled = " ",
            },
          },
          max_concurrent_installers = 10,
        }
      end,
    },
    {
      "mason-org/mason-lspconfig.nvim",
      opts = {
        ensure_installed = servers,
        automatic_enable = false,
      },
    },

    {
      "antosha417/nvim-lsp-file-operations",
      lazy = false,
      priority = 1000,
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-tree.lua",
      },
      config = function()
        require("lsp-file-operations").setup({
          debug = false,
          operations = {
            willRenameFiles = true,
            didRenameFiles = true,
            willCreateFiles = true,
            didCreateFiles = true,
            willDeleteFiles = true,
            didDeleteFiles = true,
          },
          timeout_ms = 10000,
        })
      end,
    },

    "hrsh7th/cmp-nvim-lsp",
    "nvimdev/lspsaga.nvim",
    "mfussenegger/nvim-jdtls",
  },

  config = function()
    local server_configs = require("configs.servers")
    local capabilities = require("cmp_nvim_lsp").default_capabilities()
    capabilities.textDocument.completion.completionItem =
      vim.tbl_deep_extend("force", capabilities.textDocument.completion.completionItem or {}, {
        documentationFormat = {
          "markdown",
          "plaintext",
        },
        snippetSupport = true,
        preselectSupport = true,
        insertReplaceSupport = true,
        labelDetailsSupport = true,
        deprecatedSupport = true,
        commitCharactersSupport = true,
        tagSupport = {
          valueSet = { 1 },
        },
        resolveSupport = {
          properties = {
            "documentation",
            "detail",
            "additionalTextEdits",
          },
        },
      })

    -- This tells the lsp that nvim can handle file renaming/moving
    capabilities = require("lsp-file-operations").default_capabilities(capabilities)

    local function setup()
      -- Default configurations for all servers
      vim.lsp.config("*", {
        capabilities = capabilities,
        root_markers = { ".git" },
      })

      -- Server-specific configurations
      server_configs.setup(capabilities)

      -- Enable all listed servers
      for _, s in ipairs(servers) do
        vim.lsp.enable(s)
      end
    end

    -- Run setup
    vim.schedule(setup)
  end,
}
