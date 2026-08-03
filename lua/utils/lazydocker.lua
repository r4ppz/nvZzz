-- Same as lazygit snacks

---@class utils.lazydocker
---@overload fun(opts?: utils.lazydocker.Config)
local M = setmetatable({}, {
  __call = function(t, ...)
    return t.open(...)
  end,
})

---@alias utils.lazydocker.Color {fg?:string, bg?:string, bold?:boolean}

---@class utils.lazydocker.Config: snacks.terminal.Opts
---@field args? string[]
---@field config_path? string -- generated config.yml in the cache dir
---@field user_config? string -- path to the real lazydocker config.yml
---@field theme? table<string, utils.lazydocker.Color>
local defaults = {
  -- automatically configure lazydocker to use the current colorscheme
  configure = true,
  config_path = vim.fn.stdpath("cache") .. "/lazydocker/config.yml",
  user_config = (vim.env.XDG_CONFIG_HOME or os.getenv("HOME") .. "/.config")
    .. "/lazydocker/config.yml",
  -- Theme for lazydocker (only these 4 keys are supported)
  theme = {
    activeBorderColor = { fg = "MatchParen", bold = true },
    inactiveBorderColor = { fg = "FloatBorder" },
    selectedLineBgColor = { bg = "Visual" }, -- set to `default` to have no background colour
    optionsTextColor = { fg = "Function" },
  },
  win = {
    style = "lazygit",
  },
}

-- re-create config file on startup
local dirty = true

-- re-create theme file on ColorScheme change
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    dirty = true
  end,
})

---@param v utils.lazydocker.Color
---@return string[]
local function get_color(v)
  ---@type string[]
  local color = {}
  for _, c in ipairs({ "fg", "bg" }) do
    if v[c] then
      local name = v[c]
      ---@type table<string, any>
      local hl = vim.api.nvim_get_hl(0, { name = name, link = false })
      local hl_color ---@type number?
      if c == "fg" then
        hl_color = hl and hl.fg or hl.foreground
      else
        hl_color = hl and hl.bg or hl.background
      end
      if hl_color then
        table.insert(color, string.format("#%06x", hl_color))
      end
    end
  end
  if v.bold then
    table.insert(color, "bold")
  end
  return color
end

---@param theme table<string, string[]>
---@return string[]
local function theme_block(theme)
  local block = { "  theme:" }
  for k, v in pairs(theme) do
    table.insert(block, "    " .. k .. ":")
    for _, value in ipairs(v) do
      -- hex colors must be quoted, otherwise `#` starts a comment
      table.insert(block, "      - " .. (value:match("^#") and ("%q"):format(value) or value))
    end
  end
  return block
end

---@param opts utils.lazydocker.Config
local function update_config(opts)
  ---@type table<string, string[]>
  local theme = {}

  for k, v in pairs(opts.theme) do
    theme[k] = get_color(v)
  end

  local lines = vim.fn.filereadable(opts.user_config) == 1 and vim.fn.readfile(opts.user_config)
    or {}

  -- replace the color values of the existing `gui.theme` keys in place
  local theme_found = false
  local i = 1
  while i <= #lines do
    local key = lines[i]:match("^    (%a+):$")
    if key and theme[key] then
      theme_found = true
      while (lines[i + 1] or ""):match("^      - ") do
        table.remove(lines, i + 1)
      end
      local at = i + 1
      for _, value in ipairs(theme[key]) do
        table.insert(lines, at, "      - " .. (value:match("^#") and ("%q"):format(value) or value))
        at = at + 1
      end
    end
    i = i + 1
  end

  -- config has no `gui.theme` at all: add one
  if not theme_found then
    local block = theme_block(theme)
    local out, done = {}, false
    for _, line in ipairs(lines) do
      if not done and line == "gui:" then
        table.insert(out, line)
        vim.list_extend(out, block)
        done = true
      else
        table.insert(out, line)
      end
    end
    if not done then
      vim.list_extend(out, { "gui:" })
      vim.list_extend(out, block)
    end
    lines = out
  end

  vim.fn.mkdir(vim.fn.fnamemodify(opts.config_path, ":h"), "p")
  vim.fn.writefile(lines, opts.config_path)
  dirty = false
end

---@param opts utils.lazydocker.Config
local function env(opts)
  -- lazydocker reads the CONFIG_DIR env var to find its config.yml
  vim.env.CONFIG_DIR = vim.fn.fnamemodify(opts.config_path, ":h")
end

-- Opens lazydocker, properly configured to use the current colorscheme
---@param opts? utils.lazydocker.Config
function M.open(opts)
  ---@type utils.lazydocker.Config
  opts = vim.tbl_deep_extend("force", defaults, opts or {})

  local cmd = { "lazydocker" }
  vim.list_extend(cmd, opts.args or {})

  if opts.configure then
    if dirty then
      update_config(opts)
    end
    env(opts)
  end

  return Snacks.terminal(cmd, opts)
end

return M
