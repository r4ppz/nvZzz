local window = require("utils.window")
local map = vim.keymap.set

-- Uses plugins? (other keybinds are in the plugin Lua files)

---------------------------------------------------------------------
-- BUFFERS MANAGEMENT

map("n", "<leader>n", "<cmd>enew<CR>", { desc = "Buffer new" })

-- change buffer
map(
  { "n", "v" },
  "<M-Right>",
  window.safe_buf_action(function()
    require("nvchad.tabufline").next()
  end),
  { desc = "Buffer goto next" }
)
map(
  { "n", "v" },
  "<M-Left>",
  window.safe_buf_action(function()
    require("nvchad.tabufline").prev()
  end),
  { desc = "Buffer goto prev" }
)

-- move buffer
map(
  { "n", "v" },
  "<C-M-Right>",
  window.safe_buf_action(function()
    require("nvchad.tabufline").move_buf(1)
  end),
  { desc = "move buffer to the right" }
)
map(
  { "n", "v" },
  "<C-M-Left>",
  window.safe_buf_action(function()
    require("nvchad.tabufline").move_buf(-1)
  end),
  { desc = "move buffer to the left" }
)

-- close buffer
map(
  "n",
  "<leader>q",
  window.safe_buf_action(function()
    require("nvchad.tabufline").close_buffer()
  end),
  { desc = "Buffer close" }
)

map(
  "n",
  "<M-q>",
  window.safe_buf_action(function()
    require("nvchad.tabufline").close_buffer()
  end),
  { desc = "Buffer close" }
)

map(
  "n",
  "<S-M-Q>",
  window.safe_buf_action(function()
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

---------------------------------------------------------------------
-- UI
map("n", "<leader>um", "<cmd>Mason<CR>", { desc = "Mason UI" })
map("n", "<leader>ul", "<cmd>Lazy<CR>", { desc = "Lazy UI" })
map("n", "<leader>ui", "<cmd>MasonInstallAll<cr>", { desc = "Mason Install ALl" })

---------------------------------------------------------------------
-- TERMINAL MANAGEMENT

map({ "n", "t" }, "<A-w>", function()
  window.toggle_terminal({
    pos = "float",
    id = "float_term",
  })
end, { desc = "Toggle Floating Terminal" })

map({ "n", "t" }, "<M-b>", function()
  window.toggle_terminal({
    pos = "float",
    id = "btop_float",
    float_opts = {
      row = 0.05,
      col = 0.09,
      width = 0.8,
      height = 0.8,
      border = "single",
    },
    cmd = "btop",
  })
  window.map_close_terminal("btop_float")
end, { desc = "Toggle Btop" })

-- Docker floating terminal
map({ "n", "t" }, "<M-S-d>", function()
  local system = require("utils.system")
  local cwd = vim.fn.getcwd()

  if not system.is_process_running("dockerd") then
    vim.notify("dockerd is not running", vim.log.levels.WARN)
    return
  end

  if not system.is_file_exists("docker-compose.yml", cwd) then
    vim.notify("docker-compose.yml doesn't exist in CWD", vim.log.levels.WARN)
    return
  end

  window.toggle_terminal({
    pos = "float",
    id = "lazydocker_float",
    float_opts = {
      row = 0.05,
      col = 0.05,
      width = 0.9,
      height = 0.8,
      border = "single",
    },
    cmd = "lazydocker",
  })
  window.map_close_terminal("lazydocker_float")
end, { desc = "Toggle LazyDocker" })

map({ "n", "t" }, "<A-s>", function()
  window.toggle_terminal({
    pos = "sp",
    id = "horizontal_term",
    size = 0.5,
  })
end, { desc = "Toggle Horizontal Terminal" })

map({ "n", "t" }, "<A-v>", function()
  window.toggle_terminal({
    pos = "vsp",
    id = "vertical_term",
    size = 0.5,
  })
end, { desc = "Toggle Vertical Terminal" })

map("n", "<A-t>", function()
  vim.cmd("enew")
  vim.cmd("terminal")
  vim.cmd("startinsert")
end, { desc = "New Terminal Buffer" })
