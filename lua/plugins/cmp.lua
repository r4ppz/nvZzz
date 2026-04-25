return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    {
      "L3MON4D3/LuaSnip",
      event = "InsertEnter",
      dependencies = "rafamadriz/friendly-snippets",

      opts = {
        history = true,
        updateevents = "TextChanged,TextChangedI",
      },

      config = function(_, opts)
        local ls = require("luasnip")
        ls.config.set_config(opts)

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

      config = function(_, opts)
        local npairs = require("nvim-autopairs")
        npairs.setup(opts)

        local cmp_ok, cmp = pcall(require, "cmp")
        if cmp_ok then
          local cmp_ap = require("nvim-autopairs.completion.cmp")
          cmp.event:on("confirm_done", cmp_ap.on_confirm_done())
        end
      end,
    },

    { "hrsh7th/cmp-nvim-lsp", lazy = true },
    { "hrsh7th/cmp-nvim-lua", ft = "lua" },
    { "saadparwaiz1/cmp_luasnip", event = "InsertEnter" },
    { "hrsh7th/cmp-buffer", event = "InsertEnter" },
    { "https://codeberg.org/FelipeLema/cmp-async-path.git", event = "InsertEnter" },
  },

  config = function()
    local nv_cmp = require("nvchad.cmp")
    local cmp = require("cmp")

    local disabled_ft = {
      ["TelescopePrompt"] = true,
      ["snacks_picker_input"] = true,
      ["copilot-chat"] = true,
      ["markdown"] = true,
    }

    local options = {
      enabled = function()
        -- Disable in prompt buffers
        if vim.bo.buftype == "prompt" then
          return false
        end

        return not disabled_ft[vim.bo.filetype]
      end,

      formatting = nv_cmp.formatting,
      window = vim.tbl_deep_extend("force", nv_cmp.window, {
        documentation = {
          max_width = 70,
          max_height = 15,
        },
      }),

      sorting = {
        comparators = {
          cmp.config.compare.recently_used,
          cmp.config.compare.offset,
          cmp.config.compare.exact,
          cmp.config.compare.score,
          cmp.config.compare.kind,
          cmp.config.compare.sort_text,
          cmp.config.compare.length,
          cmp.config.compare.order,
        },
      },

      preselect = cmp.PreselectMode.None,

      completion = {
        completeopt = "menu,menuone,noinsert,noselect",
      },

      snippet = {
        expand = function(args)
          require("luasnip").lsp_expand(args.body)
        end,
      },

      performance = {
        debounce = 100,
        throttle = 50,
      },

      mapping = {
        ["<C-Up>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
        ["<C-Down>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),

        -- ["<C-Up>"] = cmp.mapping.select_prev_item(),
        -- ["<C-Down>"] = cmp.mapping.select_next_item(),
        ["<S-Up>"] = cmp.mapping.scroll_docs(-4),
        ["<S-Down>"] = cmp.mapping.scroll_docs(4),
        ["<C-S-Down>"] = cmp.mapping.complete(),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-c>"] = cmp.mapping.close(),

        ["<CR>"] = cmp.mapping.confirm({
          behavior = cmp.ConfirmBehavior.Insert,
          select = false,
        }),

        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          else
            fallback()
          end
        end, { "i", "s" }),

        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          else
            fallback()
          end
        end, { "i", "s" }),
      },

      sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "buffer", max_item_count = 10 },
        { name = "async_path" },
        { name = "nvim_lua" },
      }),

      experimental = {
        ghost_text = false,
      },
    }

    cmp.setup(options)
  end,
}
