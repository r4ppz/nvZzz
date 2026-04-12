local map = vim.keymap.set

-- LazyGit floating terminal
map("n", "<M-g>", function()
  Snacks.lazygit.open()
end, { desc = "Lazygit (Snacks)" })

map("n", "<leader>gg", function()
  Snacks.lazygit.open()
end, { desc = "Lazygit (Snacks)" })

-- gitsign navigation
map("n", "]c", function()
  require("gitsigns").nav_hunk("next")
end, { desc = "Next Git Hunk (GitSign)" })
map("n", "[c", function()
  require("gitsigns").nav_hunk("prev")
end, { desc = "Previous Git Hunk (GitSign)" })

-- stage hunk/buffer
map("n", "<leader>gs", function()
  require("gitsigns").stage_hunk()
end, { desc = "Stage Hunk (GitSign)" })
map("n", "<leader>gS", function()
  require("gitsigns").stage_buffer()
end, { desc = "Stage Buffer (GitSign)" })

-- reset hunk/buffer
map("n", "<leader>gr", function()
  require("gitsigns").reset_hunk()
end, { desc = "Reset Hunk (GitSign)" })
map("n", "<leader>gR", function()
  require("gitsigns").reset_buffer()
end, { desc = "Reset Buffer (GitSign)" })

-- preview changes/blame
map("n", "<leader>gP", function()
  require("gitsigns").preview_hunk()
end, { desc = "Preview Hunk (GitSign)" })
map("n", "<leader>gp", function()
  require("gitsigns").preview_hunk_inline()
end, { desc = "Preview Hunk Inline (GitSign)" })
map("n", "<leader>gb", function()
  require("gitsigns").blame_line({ full = true })
end, { desc = "Blame Line (GitSign)" })

-- DiffView
map("n", "<leader>gd", "<cmd>DiffviewOpen<cr>", {
  desc = "Open Diffview",
})
map("n", "<leader>gh", "<cmd>DiffviewFileHistory<cr>", {
  desc = "Open Diffview History (Diffview)",
})
map("n", "<leader>gf", "<cmd>DiffviewFileHistory %<cr>", {
  desc = "Open Diffview Current File History Diffview",
})
