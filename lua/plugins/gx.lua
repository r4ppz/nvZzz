return {
  dir = "/home/r4ppz/Repositories/not-mine/gx.nvim",
  name = "gx-with-patched",

  -- "chrishrb/gx.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  cmd = { "Browse" },
  config = true,
  submodules = false,
  keys = { { "gx", "<cmd>Browse<cr>", mode = { "n", "x" } } },
}
