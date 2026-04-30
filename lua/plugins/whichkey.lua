return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  enabled = true,
  cmd = "WhichKey",
  opts = function()
    local wk = require("which-key")
    wk.add({
      { "<leader>l", group = "LSP Keybinds", icon = "󰒋" },
      { "<leader>L", group = "LSP Utils", icon = "󰒋" },
      { "<leader>g", group = "Git", icon = "󰊢" },
      { "<leader>c", group = "Copilot", icon = "" },
      { "<leader>f", group = "Picker", icon = "󰭎" },
      { "<leader>v", group = "NvChad", icon = "" },
      { "<leader>u", group = "Utils", icon = "󰏖" },
      { "<leader>F", group = "Grep", icon = "󰘳" },
      { "<leader>s", group = "Surround", icon = "" },
      { "<leader>d", group = "Diff", icon = "" },
      { "<leader>p", group = "Plugin", icon = "󰍹" },
      { "<leader>t", group = "Toggle", icon = "" },

      -- I dont use f and t anyway
      { "t", group = "Tabs", icon = "" },
      { "f", group = "Picker", icon = "󰭎" },
    })

    return {
      plugins = {
        marks = false,
        registers = false,
        spelling = {
          enabled = true,
          suggestions = 20,
        },
        presets = {
          operators = false,
          motions = false,
          text_objects = false,
          windows = false,
          nav = false,
          z = false,
          g = false,
        },
      },

      preset = "helix",
      icons = {
        group = "",
      },
      win = {
        border = "rounded",
        padding = { 1, 2 },
        title = false,
        title_pos = "center",
      },
      layout = {
        width = { min = 25, max = 50 },
        spacing = 4,
        align = "center",
      },

      sort = { "local", "group", "alphanum" },
      show_help = false,
      show_keys = false,
    }
  end,
}
