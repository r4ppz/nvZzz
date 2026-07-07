return {
  "folke/lazydev.nvim",
  ft = "lua",
  opts = {
    -- Dynamically disable lazydev if the project manages its own LuaLS environment
    enabled = function(root_dir)
      return not (
        vim.uv.fs_stat(root_dir .. "/.luarc.json") or vim.uv.fs_stat(root_dir .. "/.luarc.jsonc")
      )
    end,
    library = {
      { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      { path = "LazyVim", words = { "LazyVim" } },
      { path = "snacks.nvim", words = { "Snacks" } },
      {
        path = "ui/nvchad_types",
        words = { "nvchad", "NvChad", "chadrc" },
      },
      "nvim-dap-ui",
    },
  },
}
