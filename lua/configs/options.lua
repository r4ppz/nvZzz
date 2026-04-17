local opt = vim.opt
local o = vim.o
local g = vim.g

-- Session
opt.shada = ""

-- File Handling
o.autoread = true
o.confirm = false

-- UI
o.relativenumber = false
o.number = true
o.numberwidth = 2
o.ruler = false
o.laststatus = 3
o.showmode = false
o.equalalways = true
o.cursorline = true
o.splitbelow = true
o.splitright = true
o.cmdheight = 1
o.termguicolors = true
o.hidden = true
o.signcolumn = "yes"
o.belloff = "all"
o.splitkeep = "screen"
o.winborder = "single"
o.clipboard = "unnamedplus"
o.cursorlineopt = "number"
o.inccommand = "nosplit"
opt.fillchars = { eob = " " }
opt.pumheight = 15

-- Scrolling
o.scrolloff = 5
o.sidescroll = 1
o.sidescrolloff = 8

-- Wrapping
o.wrap = false
o.linebreak = true
o.breakindent = true
o.showbreak = " "

-- Indentation
o.expandtab = true
o.shiftwidth = 2
o.smartindent = true
o.autoindent = true
o.tabstop = 2
o.softtabstop = 2

-- Search
o.ignorecase = true
o.smartcase = true

-- Mouse
o.mouse = "a"

-- Performance
o.updatetime = 300
o.lazyredraw = true
o.ttyfast = true
o.fdo = "search,tag,insert,undo"
o.synmaxcol = 200
o.timeoutlen = 300
o.undofile = true

-- Misc
opt.shortmess:append("sI")
opt.whichwrap:append("<>[]")

-- Disable default providers
g.loaded_node_provider = 0
g.loaded_python3_provider = 0
g.loaded_perl_provider = 0
g.loaded_ruby_provider = 0

-- Add binaries installed by mason.nvim to PATH
local is_windows = vim.fn.has("win32") ~= 0
local sep = is_windows and "\\" or "/"
local delim = is_windows and ";" or ":"
vim.env.PATH = table.concat({ vim.fn.stdpath("data"), "mason", "bin" }, sep)
  .. delim
  .. vim.env.PATH
