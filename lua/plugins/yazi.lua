return {
  "mikavilpas/yazi.nvim",
  version = "*",
  dependencies = {
    { "nvim-lua/plenary.nvim", lazy = true },
  },
  opts = {
    floating_window_scaling_factor = 0.6,
    yazi_floating_window_border = "single",
    open_for_directories = false,
    keymaps = {
      show_help = "<f1>",
    },
  },

  keys = {
    {
      "\\",
      "<cmd>Yazi cwd<cr>",
      desc = "Open the file manager in nvim's working directory",
    },

    {
      "<leader>e",
      mode = { "n", "v" },
      "<cmd>Yazi<cr>",
      desc = "Open yazi at the current file",
    },
  },
}
