local layout = require("utils.layout")
local logo_header = require("utils.logo")

return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    gh = {},
    image = {
      enabled = false,
    },

    lazygit = {
      configure = true,
      env = {
        GIT_EDITOR = "lazygit-commit.sh",
      },
    },

    bigfile = {
      notify = true,
      size = 1.5 * 1024 * 1024,
      line_length = 1000,
      line_count = 20000,
    },

    words = {
      enabled = false, -- I prefer vim-illuminate
    },

    notifier = {
      enabled = false,
      level = vim.log.levels.TRACE,
      top_down = true,
      margin = { top = 1, right = 1, bottom = 0 },
    },

    dashboard = {
      enabled = true,
      preset = {
        header = logo_header,
      },
      sections = {
        { section = "header" },
        { section = "startup" },
      },
    },

    picker = {
      enabled = true,

      sources = {
        gh_issue = {},
        gh_pr = {},

        files = { hidden = true, ignored = false },
        grep = { hidden = true },
      },

      win = {
        input = {
          keys = {
            ["<Esc>"] = { "close", mode = { "n", "i" } },
            ["<C-Up>"] = { "preview_scroll_up", mode = { "i", "n" } },
            ["<C-Down>"] = { "preview_scroll_down", mode = { "i", "n" } },
            ["<S-UP>"] = { "list_scroll_up", mode = { "i", "n" } },
            ["<S-Down>"] = { "list_scroll_down", mode = { "i", "n" } },
          },
        },
      },
    },
  },
  keys = {
    {
      "<leader>Gi",
      function()
        Snacks.picker.gh_issue()
      end,
      desc = "GitHub Issues (open)",
    },
    {
      "<leader>GI",
      function()
        Snacks.picker.gh_issue({ state = "all" })
      end,
      desc = "GitHub Issues (all)",
    },
    {
      "<leader>Gp",
      function()
        Snacks.picker.gh_pr()
      end,
      desc = "GitHub Pull Requests (open)",
    },
    {
      "<leader>GP",
      function()
        Snacks.picker.gh_pr({ state = "all" })
      end,
      desc = "GitHub Pull Requests (all)",
    },

    {
      "<M-f>",
      function()
        Snacks.picker.files()
      end,
      desc = "Find Files (Snacks)",
    },

    {
      "<leader>ff",
      function()
        Snacks.picker.files()
      end,
      desc = "Find Files (Snacks)",
    },

    {
      "ff",
      function()
        Snacks.picker.smart()
      end,
      desc = "Smart Find Files (Snacks)",
    },

    {
      "fg",
      function()
        Snacks.picker.grep()
      end,
      desc = "Grep (Snacks)",
    },

    {
      "fG",
      function()
        Snacks.picker.grep_buffers({
          auto_confirm = false,
          title = "References",
          layout = layout.bottom,
        })
      end,
      desc = "Grep Current Buffer (Snacks)",
    },

    {
      "fb",
      function()
        Snacks.picker.buffers()
      end,
      desc = "Buffers (Snacks)",
    },

    {
      "<leader>fg",
      function()
        Snacks.picker.grep()
      end,
      desc = "Grep (Snacks)",
    },

    {
      "<leader>fc",
      function()
        Snacks.picker.colorschemes()
      end,
      desc = "Colorschemes",
    },

    {
      "<leader>fH",
      function()
        Snacks.picker.files({ dirs = { os.getenv("HOME") } })
      end,
      desc = "Fuzzy Find from Home (Snacks)",
    },

    {
      "<leader>fG",
      function()
        Snacks.picker.grep_buffers({
          auto_confirm = false,
          title = "References",
          layout = layout.bottom,
        })
      end,
      desc = "Grep Current Buffer (Snacks)",
    },

    {
      "<leader>fh",
      function()
        Snacks.picker.help()
      end,
      desc = "Help tags (Snacks)",
    },

    {
      "<leader>fm",
      function()
        Snacks.picker.marks()
      end,
      desc = "Marks (Snacks)",
    },

    {
      "<leader>fM",
      function()
        Snacks.picker.man()
      end,
      desc = "Man Pages (Snacks)",
    },

    {
      "<leader>fb",
      function()
        Snacks.picker.buffers()
      end,
      desc = "Buffers (Snacks)",
    },
  },
}
