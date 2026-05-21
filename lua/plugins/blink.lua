return {
  {
    "L3MON4D3/LuaSnip",
    dependencies = { "rafamadriz/friendly-snippets" },
    event = "InsertEnter",
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
    event = "InsertEnter",
    opts = {
      fast_wrap = {},
      disable_filetype = { "TelescopePrompt", "vim" },
    },
  },

  {
    "saghen/blink.cmp",
    version = "1.*",
    event = { "CmdLineEnter", "InsertEnter" },

    dependencies = {
      "rafamadriz/friendly-snippets",
    },

    opts = function()
      local nv_blink = require("nvchad.blink.config")

      return vim.tbl_deep_extend("force", nv_blink, {
        completion = {
          documentation = {
            auto_show = true,
            auto_show_delay_ms = 500,
            window = {
              border = "single",
              max_height = 15,
              max_width = 70,
            },
          },

          ghost_text = { enabled = false },

          list = {
            selection = {
              auto_insert = false,
              preselect = false,
            },
          },

          menu = {
            draw = {
              components = {
                label = {
                  width = { max = 30 },
                },
              },
            },
            max_height = 15,
            scrollbar = false,
          },
        },

        enabled = function()
          local ft = vim.bo.filetype
          local bt = vim.bo.buftype

          if bt == "prompt" then
            return false
          end

          local disabled = {
            ["copilot-chat"] = true,
            markdown = true,
            snacks_picker_input = true,
            TelescopePrompt = true,
          }

          return not disabled[ft]
        end,

        fuzzy = {
          implementation = "prefer_rust",
          sorts = { "kind", "exact", "score", "sort_text" },
        },

        keymap = {
          preset = "none",
          ["<C-Up>"] = { "select_prev", "fallback" },
          ["<C-Down>"] = { "select_next", "fallback" },

          ["<S-Tab>"] = { "insert_prev", "snippet_forward", "fallback" },
          ["<Tab>"] = {
            function(cmp)
              if cmp.is_visible() then
                return cmp.select_next()
              elseif cmp.snippet_active() then
                return cmp.snippet_forward()
              end
            end,
            "fallback",
          },

          ["<S-Down>"] = { "scroll_documentation_down", "fallback" },
          ["<S-Up>"] = { "scroll_documentation_up", "fallback" },

          ["<C-S-Down>"] = { "show", "show_documentation", "hide_documentation", "fallback" },
          ["<C-Space>"] = { "show", "show_documentation", "hide_documentation", "fallback" },
          ["<C-c>"] = { "hide", "fallback" },

          ["<CR>"] = { "accept", "fallback" },
        },

        signature = {
          enabled = false,
          window = {
            border = "single",
            max_height = 8,
            max_width = 80,
          },
        },

        sources = {
          default = { "lsp", "snippets", "buffer", "path" },
          providers = {
            buffer = {
              max_items = 20,
              min_keyword_length = 2,
            },
            path = {
              min_keyword_length = 2,
            },
          },
        },
      })
    end,
  },
}
