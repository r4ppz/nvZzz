local map = require("utils.map")

---------------------------------------------------------------------
-- TERMINAL MANAGEMENT
local focus_main_window = require("utils.focus_main_window")

-- Keymaps
map({ "n", "t" }, "<A-w>", function()
  focus_main_window()
  require("nvchad.term").toggle({
    pos = "float",
    id = "float_term",
  })
end, { desc = "Toggle Floating Terminal" })

map({ "n", "t" }, "<M-b>", function()
  focus_main_window()
  local term = require("nvchad.term")
  term.toggle({
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

  -- map q to close/toggle the terminal
  local buf = vim.api.nvim_get_current_buf()
  map("t", "q", function()
    term.toggle({ id = "btop_float" })
  end, { buffer = buf })
end, { desc = "Toggle Btop" })

-- Docker floating terminal
map({ "n", "t" }, "<M-S-d>", function()
  local function is_process_running(name)
    local handle = io.popen("pgrep -x " .. name)
    if not handle then
      return false
    end
    local result = handle:read("*a")
    handle:close()
    return result ~= ""
  end

  local function is_file_exists(file, dir)
    local path = dir .. "/" .. file
    local f = io.open(path, "r")
    if f ~= nil then
      f:close()
      return true
    end
    return false
  end

  local cwd = vim.fn.getcwd()

  if not is_process_running("dockerd") then
    vim.notify("dockerd is not running", vim.log.levels.WARN)
    return
  end

  if not is_file_exists("docker-compose.yml", cwd) then
    vim.notify("docker-compose.yml doesn't exist in CWD", vim.log.levels.WARN)
    return
  end

  focus_main_window()
  local term = require("nvchad.term")
  term.toggle({
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

  -- map q to close/toggle the terminal
  local buf = vim.api.nvim_get_current_buf()
  map("t", "q", function()
    term.toggle({ id = "lazydocker_float" })
  end, { buffer = buf })
end, { desc = "Toggle LazyDocker" })

map({ "n", "t" }, "<A-s>", function()
  focus_main_window()
  require("nvchad.term").toggle({
    pos = "sp",
    id = "horizontal_term",
    size = 0.5,
  })
end, { desc = "Toggle Horizontal Terminal" })

map({ "n", "t" }, "<A-v>", function()
  focus_main_window()
  require("nvchad.term").toggle({
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
