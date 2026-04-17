return {
  "nvim-pack/nvim-spectre",
  dependencies = { "nvim-lua/plenary.nvim" },
  event = "VeryLazy",
  cmd = "Spectre",
  keys = {
    {
      "<leader>/",
      function()
        require("utils.window").toggle_panel(function()
          require("spectre").toggle()
        end, "spectre_panel")
      end,
      mode = { "v", "n" },
      desc = "Toggle Spectre",
    },
    {
      "<leader>?",
      function()
        require("utils.window").toggle_panel(function()
          require("spectre").open_file_search()
        end, "spectre_panel")
      end,
      mode = { "n", "v" },
      desc = "Search on current file",
    },
  },
}
