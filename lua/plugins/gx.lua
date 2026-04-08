return {
  "chrishrb/gx.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  cmd = { "Browse" },
  submodules = false,
  keys = { { "gx", "<cmd>Browse<cr>", mode = { "n", "x" } } },
  init = function()
    vim.g.netrw_nogx = 1
  end,
  config = function()
    require("gx").setup({
      handler_options = {
        search_engine = "duckduckgo",
      },
    })
  end,
}
