local opt = vim.opt

-- Session
opt.shada = ""

-- File Handling
opt.autoread = true
opt.confirm = false

-- UI
opt.relativenumber = false
opt.number = true
opt.numberwidth = 2
opt.ruler = false
opt.laststatus = 3
opt.showmode = false
opt.equalalways = true
opt.cursorline = true
opt.splitbelow = true
opt.splitright = true
opt.cmdheight = 1
opt.termguicolors = true
opt.hidden = true
opt.signcolumn = "yes:1"
opt.belloff = "all"
opt.splitkeep = "screen"
opt.winborder = "single"
opt.clipboard = "unnamedplus"
opt.cursorlineopt = "number"
opt.inccommand = "nosplit"

opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldlevelstart = 99

opt.smarttab = true
opt.fillchars = { eob = " " }
opt.pumheight = 15
opt.diffopt = {
  "internal",
  "filler",
  "closeoff",
  "vertical",
  "algorithm:histogram",
  "inline:char",
  "linematch:60",
  "indent-heuristic",
  "hiddenoff",
}

-- Scrolling
opt.scrolloff = 5
opt.sidescroll = 1
opt.sidescrolloff = 8

-- Wrapping
opt.wrap = false
opt.linebreak = true
opt.breakindent = true
opt.showbreak = " "

-- Indentation
opt.expandtab = true
opt.shiftwidth = 2
opt.smartindent = true
opt.autoindent = true
opt.tabstop = 2
opt.softtabstop = 2

-- Search
opt.ignorecase = true
opt.smartcase = true

-- Mouse
opt.mouse = "a"
opt.mousemodel = "extend"

-- Performance
opt.updatetime = 300

opt.fdo = "search,tag,insert,undo"
opt.synmaxcol = 200
opt.timeoutlen = 300
opt.undofile = true

-- Misc
opt.shortmess:append("sI")
opt.whichwrap:append("<>[]")

-- Disable default providers
vim.g.loaded_node_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
