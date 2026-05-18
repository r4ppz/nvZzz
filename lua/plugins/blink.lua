return {
  {
    "saghen/blink.cmp",
    version = "1.*",
    event = { "InsertEnter", "CmdLineEnter" },

    dependencies = {
      {
        "L3MON4D3/LuaSnip",
        dependencies = { "rafamadriz/friendly-snippets" },
        opts = {
          history = true,
          updateevents = "TextChanged,TextChangedI",
        },
        config = function(_, opts)
          require("luasnip").config.set_config(opts)
          require("luasnip.loaders.from_vscode").lazy_load()
          require("luasnip.loaders.from_snipmate").lazy_load()
          require("luasnip.loaders.from_lua").lazy_load()
        end,
      },

      {
        "windwp/nvim-autopairs",
        opts = {
          fast_wrap = {},
          disable_filetype = { "TelescopePrompt", "vim" },
        },
        config = function(_, opts)
          require("nvim-autopairs").setup(opts)
        end,
      },
    },

    opts = function()
      local nv_blink = require("nvchad.blink.config")

      return vim.tbl_deep_extend("force", nv_blink, {
        enabled = function()
          local disabled_ft = {
            TelescopePrompt = true,
            snacks_picker_input = true,
            ["copilot-chat"] = true,
            markdown = true,
          }

          if vim.bo.buftype == "prompt" then
            return false
          end

          return not disabled_ft[vim.bo.filetype]
        end,

        keymap = {
          preset = "none",

          ["<C-Up>"] = { "select_prev", "fallback" },
          ["<C-Down>"] = { "select_next", "fallback" },

          ["<S-Up>"] = { "scroll_documentation_up", "fallback" },
          ["<S-Down>"] = { "scroll_documentation_down", "fallback" },

          ["<C-S-Down>"] = { "show", "show_documentation", "hide_documentation", "fallback" },
          ["<C-Space>"] = { "show", "show_documentation", "hide_documentation", "fallback" },
          ["<C-c>"] = { "hide", "fallback" },

          ["<CR>"] = { "accept", "fallback" },

          ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
          ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
        },

        sources = {
          default = { "lsp", "snippets", "buffer", "path" },

          providers = {
            buffer = {
              max_items = 20,
            },
          },
        },

        completion = {
          list = {
            selection = {
              preselect = false,
              auto_insert = false,
            },
          },

          ghost_text = { enabled = false },

          menu = {
            draw = {
              components = {
                label = {
                  width = { max = 30 },
                },
              },
            },
          },

          documentation = {
            auto_show = true,
            auto_show_delay_ms = 200,
            window = {
              max_width = 70,
              max_height = 15,
              border = "single",
            },
          },
        },
      })
    end,
  },
}
