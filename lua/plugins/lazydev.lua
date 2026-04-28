return {
  "folke/lazydev.nvim",
  ft = "lua",
  opts = {
    library = {
      { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      { path = "LazyVim", words = { "LazyVim" } },
      {
        path = "ui/nvchad_types",
        words = { "nvchad", "NvChad", "chadrc" },
      },
    },
  },
}
