local servers = require("configs.servers.servers")

return {
  {
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
          ensure_installed = servers.server_list,
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
      "mfussenegger/nvim-jdtls",
    },

    config = function()
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
      capabilities = vim.tbl_deep_extend(
        "force",
        capabilities,
        require("lsp-file-operations").default_capabilities()
      )

      -- colorify replacement
      vim.lsp.document_color.enable(true, nil, { style = "virtual" })

      local function setup()
        -- Default configurations for all servers
        vim.lsp.config("*", {
          capabilities = capabilities,
          root_markers = { ".git" },
        })

        -- Server-specific configurations
        servers.setup(capabilities)

        -- Enable all listed servers
        for _, s in ipairs(servers.server_list) do
          vim.lsp.enable(s)
        end
      end

      -- Run setup
      vim.schedule(setup)
    end,
  },

  {
    "nvimdev/lspsaga.nvim",
    event = "LspAttach",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      vim.diagnostic.config({
        virtual_text = false,
      })

      require("lspsaga").setup({
        symbol_in_winbar = {
          enable = false,
        },
        outline = {
          win_position = "right",
          win_width = 50,
          max_height = 0.3,
          left_width = 0.3,
          keys = {
            toggle_or_jump = "<CR>",
            jump = "e",
          },
        },
        hover = {
          max_width = 0.5,
        },
        lightbulb = {
          enable = false,
          sign = true,
          virtual_text = false,
          debounce = 10,
          sign_priority = 40,
        },
        ui = {
          code_action = "",
          border = "single",
          title = true,
          expand = "",
          collapse = "",
          actionfix = " ",
          lines = { "", "", "│", "", "" },
          imp_sign = "󰳛 ",
        },
        finder = {
          max_height = 0.5,
          left_width = 0.4,
          right_width = 0.6,
          default = "ref",
          layout = "float",
          silent = true,
          keys = {
            vsplit = "v",
            split = "s",
            toggle_or_open = "<CR>",
            shuttle = "<S-Right>",
            quit = "q",
          },
        },
        definition = {
          keys = {
            edit = "<CR>",
            vsplit = "v",
            split = "s",
          },
        },
        rename = {
          in_select = false,
          quit = "<ESC>",
        },
        diagnostic = {
          extend_relatedInformation = true,
          show_layout = "float",
          max_show_width = 0.5,
          keys = {
            quit = "q",
            quit_in_show = { "q", "<ESC>" },
            toggle_or_jump = "<CR>",
          },
        },
      })
    end,
  },
}
