return {
  "andymass/vim-matchup",
  event = "VeryLazy",
  config = function()
    vim.g.matchup_matchparen_offscreen = {}
    vim.g.matchup_matchparen_enabled = 1
    vim.g.matchup_motion_enabled = 1
    vim.g.matchup_text_obj_enabled = 1
    vim.g.matchup_matchparen_deferred = 1
    vim.g.matchup_delim_noskips = 1
    vim.g.matchup_treesitter_disable_virtual_text = true

    pcall(function()
      require("nvim-treesitter.configs").setup({
        highlight = { enable = true },
        matchup = { enable = true },
      })
    end)

    vim.keymap.set({ "n", "x", "o" }, "~", "<Plug>(matchup-%)", { desc = "Jump to matching pair" })
  end,
}
