return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    lazygit = {
      configure = true,
      env = {
        GIT_EDITOR = "lazygit-commit.sh",
      },
    },

    bigfile = {},

    notifier = {
      enabled = false,
      level = vim.log.levels.TRACE,
      top_down = true,
      margin = { top = 1, right = 1, bottom = 0 },
    },

    picker = {
      enabled = true,
      sources = {
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
      "<leader>bf",
      function()
        Snacks.picker.grep_buffers({
          auto_confirm = false,
          title = "References",
          layout = {
            layout = {
              box = "vertical",
              row = -1,
              width = 0,
              height = 0.5,
              border = "top",
              { win = "input", height = 1, border = "bottom" },
              {
                box = "horizontal",
                {
                  win = "list",
                  border = "none",
                },
                {
                  win = "preview",
                  title = "{preview}",
                  width = 0.5,
                  border = "left",
                },
              },
            },
          },
        })
      end,
      desc = "Grep Current Buffer (Snacks)",
    },

    {
      "<leader>ft",
      function()
        Snacks.picker.todo_comments()
      end,
      desc = "Todo (Snacks)",
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
      "<leader>bl",
      function()
        Snacks.picker.lines()
      end,
      desc = "Buffer Lines (Snacks)",
    },

    {
      "<leader>bb",
      function()
        Snacks.picker.buffers()
      end,
      desc = "Buffers (Snacks)",
    },
  },
}
