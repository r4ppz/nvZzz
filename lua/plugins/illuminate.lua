return {
  "RRethy/vim-illuminate",
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    require("illuminate").configure({
      providers = {
        "lsp",
        "treesitter",
      },
      delay = 200,
      filetypes_denylist = {
        "dirvish",
        "fugitive",
        "alpha",
        "dashboard",
        "packer",
        "neogitstatus",
        "NvimTree",
        "terminal",
        "lazy",
        "mason",
        "notify",
        "toggleterm",
        "lazyterm",
        "copilot-chat",
        "help",
        "man",
        "DiffviewFiles",
        "DiffviewFileHistory",
        "markdown",
        "TelescopePrompt",
        "TelescopeResults",
      },
      min_count_to_highlight = 2,
      under_cursor = true,
    })
  end,

  keys = {
    {
      "[r",
      function()
        require("illuminate").goto_prev_reference()
      end,
      mode = { "n", "v" },
      desc = "Prev Reference (vim-illuminate)",
    },
    {
      "]r",
      function()
        require("illuminate").goto_next_reference()
      end,
      mode = { "n", "v" },
      desc = "Next Reference (vim-illuminate)",
    },
  },
}
