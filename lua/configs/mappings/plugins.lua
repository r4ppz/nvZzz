local map = require("utils.map")

-- Plugins? (other keybinds are in the plugins lua files)

---------------------------------------------------------------------
-- BUFFERS MANAGEMENT
local safe_buf_action = require("utils.safe_buf_action")

map("n", "<leader>n", "<cmd>enew<CR>", { desc = "Buffer new" })

-- change buffer
map(
  { "n", "v" },
  "<M-Right>",
  safe_buf_action(function()
    require("nvchad.tabufline").next()
  end),
  { desc = "Buffer goto next" }
)
map(
  { "n", "v" },
  "<M-Left>",
  safe_buf_action(function()
    require("nvchad.tabufline").prev()
  end),
  { desc = "Buffer goto prev" }
)

-- move buffer
map(
  { "n", "v" },
  "<C-M-Right>",
  safe_buf_action(function()
    require("nvchad.tabufline").move_buf(1)
  end),
  { desc = "move buffer to the right" }
)
map(
  { "n", "v" },
  "<C-M-Left>",
  safe_buf_action(function()
    require("nvchad.tabufline").move_buf(-1)
  end),
  { desc = "move buffer to the left" }
)

-- close buffer
map(
  "n",
  "<leader>q",
  safe_buf_action(function()
    require("nvchad.tabufline").close_buffer()
  end),
  { desc = "Buffer close" }
)

map(
  "n",
  "<M-q>",
  safe_buf_action(function()
    require("nvchad.tabufline").close_buffer()
  end),
  { desc = "Buffer close" }
)

map(
  "n",
  "<S-M-Q>",
  safe_buf_action(function()
    require("nvchad.tabufline").closeAllBufs(false)
  end),
  { desc = "Close all buffers except current" }
)

---------------------------------------------------------------------
-- NVCHAD I think

map("n", "<leader>vc", "<cmd>NvCheatsheet<CR>", { desc = "toggle nvcheatsheet" })
map("n", "<leader>vt", function()
  require("nvchad.themes").open()
end, { desc = "telescope nvchad themes" })

-- UI
map("n", "<leader>um", "<cmd>Mason<CR>", { desc = "Mason UI" })
map("n", "<leader>ul", "<cmd>Lazy<CR>", { desc = "Lazy UI" })
map("n", "<leader>ui", "<cmd>MasonInstallAll<cr>", { desc = "Mason Install ALl" })

-- Keyboard users
map("n", "<C-t>", function()
  require("menu").open("default")
end, {})

-- mouse users + nvimtree users!
map({ "n", "v" }, "<RightMouse>", function()
  require("menu.utils").delete_old_menus()

  vim.cmd.exec('"normal! \\<RightMouse>"')

  -- clicked buf
  local buf = vim.api.nvim_win_get_buf(vim.fn.getmousepos().winid)
  local options = vim.bo[buf].ft == "NvimTree" and "nvimtree" or "default"

  require("menu").open(options, { mouse = true })
end, {})
