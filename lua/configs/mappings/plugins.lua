local win_util = require("utils.window")
local map = require("utils.map")

-- Uses plugins? (other keybinds are in the plugin Lua files)

---------------------------------------------------------------------
-- BUFFERS MANAGEMENT

map("n", "<leader>n", "<cmd>enew<CR>", { desc = "Buffer new" })

-- change buffer
map(
  { "n", "v" },
  "<M-Right>",
  win_util.safe_buf_action(function()
    require("nvchad.tabufline").next()
  end),
  { desc = "Buffer goto next" }
)
map(
  { "n", "v" },
  "<M-Left>",
  win_util.safe_buf_action(function()
    require("nvchad.tabufline").prev()
  end),
  { desc = "Buffer goto prev" }
)

-- move buffer
map(
  { "n", "v" },
  "<C-M-Right>",
  win_util.safe_buf_action(function()
    require("nvchad.tabufline").move_buf(1)
  end),
  { desc = "move buffer to the right" }
)
map(
  { "n", "v" },
  "<C-M-Left>",
  win_util.safe_buf_action(function()
    require("nvchad.tabufline").move_buf(-1)
  end),
  { desc = "move buffer to the left" }
)

-- close buffer
map(
  "n",
  "<M-q>",
  win_util.safe_buf_action(function()
    require("nvchad.tabufline").close_buffer()
  end),
  { desc = "Buffer close" }
)

map(
  "n",
  "<S-M-Q>",
  win_util.safe_buf_action(function()
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
-- TERMINAL MANAGEMENT

local function map_close_terminal(config, extra_key)
  local map_local = vim.keymap.set
  -- Default
  map_local("t", "<M-q>", function()
    require("nvchad.term").toggle(config)
  end, { buffer = 0 })

  -- Optionally add an extra close key
  if extra_key then
    map_local("t", extra_key, function()
      require("nvchad.term").toggle(config)
    end, { buffer = 0 })
  end
end

map({ "n", "t" }, "<A-w>", function()
  local config = {
    pos = "float",
    id = "float_term",
  }

  win_util.focus_main_window()
  require("nvchad.term").toggle(config)
  map_close_terminal(config)
end, { desc = "Toggle Floating Terminal" })

map({ "n", "t" }, "<M-b>", function()
  local config = {
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
  }

  win_util.toggle_panel(function()
    win_util.focus_main_window()
    require("nvchad.term").toggle(config)
  end, "NvTerm_float")

  map_close_terminal(config, "q")
end, { desc = "Toggle Btop" })

-- Docker floating terminal
map({ "n", "t" }, { "<M-S-d>", "<leader>td" }, function()
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

  local config = {
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
  }

  win_util.focus_main_window()
  require("nvchad.term").toggle(config)
  map_close_terminal(config, "q")
end, { desc = "Toggle LazyDocker" })

map({ "n", "t" }, { "<M-s>", "<leader>ts" }, function()
  local config = {
    pos = "sp",
    id = "horizontal_term",
    size = 0.5,
  }

  win_util.toggle_panel(function()
    win_util.focus_main_window()
    require("nvchad.term").toggle(config)
  end, "NvTerm_sp")

  map_close_terminal(config, "<M-c>")
end, { desc = "Toggle Horizontal Terminal" })

map({ "n", "t" }, { "<M-v>", "<leader>tv" }, function()
  local config = {
    pos = "vsp",
    id = "vertical_term",
    size = 0.5,
  }

  win_util.toggle_panel(function()
    win_util.focus_main_window()
    require("nvchad.term").toggle(config)
  end, "NvTerm_vsp")

  map_close_terminal(config, "<M-c>")
end, { desc = "Toggle Vertical Terminal" })

map("n", "<A-t>", function()
  vim.cmd("enew")
  vim.cmd("terminal")
  vim.cmd("startinsert")
end, { desc = "New Terminal Buffer" })

--------------------------------------------------------
-- Utils
map({ "n", "v" }, "<leader>ub", "<cmd>BufInfo<CR>", { desc = "Get BufInfo" })
map({ "n", "v" }, "<leader>uc", "<CMD>OpenConfig<CR>", { desc = "Open Neovim Config" })
map({ "n", "v" }, "<leader>uh", "<cmd>checkhealth<cr>", { desc = "Check Health" })
map({ "n", "v" }, "<leader>um", "<cmd>MarkdownPreview<cr>", { desc = "Markdown preview" })
map({ "n", "v" }, "<leader>uf", function()
  require("conform").format({
    timeout_ms = 1000,
    async = true,
  })
end, { desc = "Format & Autofix File" })

map("n", "<leader>uf", function()
  vim.cmd("luafile %")
end, { desc = "Run current Lua file" })

map("v", "<leader>ue", function()
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")

  local lines = vim.api.nvim_buf_get_lines(0, start_pos[2] - 1, end_pos[2], false)

  local chunk = table.concat(lines, "\n")

  local fn, err = loadstring(chunk)
  if not fn then
    print(err)
    return
  end

  local ok, result = pcall(fn)
  if not ok then
    print(result)
    return
  end

  if result ~= nil then
    print(vim.inspect(result))
  end
end, { desc = "Run selected Lua snippet" })

--------------------------------------------------------
-- Toggle
map("n", "<leader>tw", function()
  vim.wo.wrap = not vim.wo.wrap
end, { desc = "Toggle line wrapping" })

map("n", "<leader>tm", function()
  require("render-markdown").toggle()
end, { desc = "Toggle render-markdown" })

---------------------------------------------------------------------
map({ "n", "v" }, "<leader>pm", "<cmd>Mason<CR>", { desc = "Mason UI" })
map({ "n", "v" }, "<leader>pl", "<cmd>Lazy<CR>", { desc = "Lazy UI" })
map({ "n", "v" }, "<leader>pi", "<cmd>MasonInstallAll<cr>", { desc = "Mason Install ALl" })
