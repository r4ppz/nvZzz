return {
  {
    "brianhuster/live-preview.nvim",
    dependencies = {
      "folke/snacks.nvim",
    },
    keys = {
      {
        "<leader>up",
        "<cmd>LivePreview start<CR>",
        desc = "Start Live Preview",
      },
    },
  },

  {
    "MeanderingProgrammer/render-markdown.nvim",
    enabled = true,
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      render_modes = true,

      completions = {
        lsp = {
          enabled = true,
        },
      },

      latex = {
        enabled = true,
      },

      heading = {
        atx = false,
        icons = { "# ", "## ", "### ", "#### ", "##### ", "###### " },
      },

      bullet = {
        icons = { "-", "-", "-", "-" },
      },

      code = {
        conceal_delimiters = true,
      },

      anti_conceal = {
        enabled = false,
      },

      sign = {
        enabled = false,
      },

      win_options = {
        conceallevel = { default = vim.o.conceallevel, rendered = 3 },
      },

      link = {
        enabled = true,
      },
    },
    ft = { "copilot-chat", "markdown" },
  },
}
