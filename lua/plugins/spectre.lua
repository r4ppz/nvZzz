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
      desc = "Toggle Spectre",
    },
    {
      "<leader>/w",
      function()
        require("utils.window").toggle_panel(function()
          require("spectre").open_visual({ select_word = true })
        end, "spectre_panel")
      end,
      desc = "Search current word",
    },
    {
      "<leader>/w",
      function()
        require("utils.window").toggle_panel(function()
          require("spectre").open_visual()
        end, "spectre_panel")
      end,
      mode = "v",
      desc = "Search current word",
    },
    {
      "<leader>/p",
      function()
        require("utils.window").toggle_panel(function()
          require("spectre").open_file_search({ select_word = true })
        end, "spectre_panel")
      end,
      desc = "Search on current file",
    },
  },
}
