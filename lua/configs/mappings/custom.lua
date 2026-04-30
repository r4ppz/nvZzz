local map = vim.keymap.set

--------------------------------------------------------
-- Personal?!!
--------------------------------------------------------

-- Move line Up/Down
map("n", "<C-A-Up>", ":m .-2<CR>==<C-l>", { desc = "Move line up" })
map("n", "<C-A-Down>", ":m .+1<CR>==<C-l>", { desc = "Move line down" })
map("v", "<C-A-Up>", ":m '<-2<CR>gv=gv<C-l>", { desc = "Move selection up" })
map("v", "<C-A-Down>", ":m '>+1<CR>gv=gv<C-l>", { desc = "Move selection down" })

-- Insert below and above
map("n", "<M-Up>", "O", { desc = "Insert above" })
map("n", "<M-Down>", "o", { desc = "Insert below" })
map("i", "<M-Up>", "<C-o>O", { desc = "Insert above" })
map("i", "<M-Down>", "<C-o>o", { desc = "Insert below" })

-- Undo and redo (this is like 10x better)
map("n", "<M-a>", "u", { desc = "Undo" })
map("i", "<M-a>", "<C-o>u", { desc = "Undo (Insert)" })
map("v", "<M-a>", "u", { desc = "Undo (Visual)" })
map("n", "<M-d>", "<C-r>", { desc = "Redo" })
map("i", "<M-d>", "<C-o><C-r>", { desc = "Redo (Insert)" })
map("v", "<M-d>", "<C-r>", { desc = "Redo (Visual)" })

-- Scroll half page and center
map("n", "<S-Up>", "<C-u>zz", { desc = "Scroll half a page up and center" })
map("n", "<S-Down>", "<C-d>zz", { desc = "Scroll half a page down and center" })
map("i", "<S-Up>", "<C-o><C-u><C-o>zz", {
  desc = "Scroll half a page up and center in insert mode",
})
map("i", "<S-Down>", "<C-o><C-d><C-o>zz", {
  desc = "Scroll half a page down and center in insert mode",
})

-- Just for consistency
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll half a page up and center" })
map("n", "<S-d>", "<C-d>zz", { desc = "Scroll half a page down and center" })

-- Jump by paragraph while selecting
map("v", "<S-Up>", "{", { desc = "Jump to previous paragraph" })
map("v", "<S-Down>", "}", { desc = "Jump to next paragraph" })

-- Ctrl+Left/Right word navigation (like any other GUI's)
map({ "n", "v" }, "<C-Left>", "b", { desc = "Move to the beginning of the word" })
map({ "n", "v" }, "<C-Right>", "e", { desc = "Move to the end of the word" })
map("i", "<C-Left>", "<C-o>b", { desc = "Move to the beginning of the word in insert mode" })
map("i", "<C-Right>", "<C-o>e<C-o>a", { desc = "Move to the end of the word in insert mode" })
map({ "n", "v" }, "<S-Right>", "E", { desc = "Move Right like E" })
map({ "n", "v" }, "<S-Left>", "B", { desc = "Move Left like B" })
map("i", "<S-Left>", "<C-o>B", { desc = "Move to the beginning of the word like B in insert mode" })
map("i", "<S-Right>", "<C-o>E<C-o>a", {
  desc = "Move to the end of the word like E in insert mode",
})

-- Emacs style :p
map("i", "<C-a>", "<Home>", { desc = "Move cursor to the beginning of the line in insert mode" })
map("i", "<C-e>", "<End>", { desc = "Move cursor to the end of the line in insert mode" })

-- Ctrl+Up/Down scroll one line
map({ "n", "v" }, "<C-Down>", "<C-e>", { desc = "Scroll window down one line" })
map({ "n", "v" }, "<C-Up>", "<C-y>", { desc = "Scroll window up one line" })
map("i", "<C-Down>", "<C-o><C-e>", { desc = "Scroll window down one line in insert mode" })
map("i", "<C-Up>", "<C-o><C-y>", { desc = "Scroll window up one line in insert mode" })

-- Indent line
map("v", "<", "<gv", { desc = "Indent left and reselect" })
map("v", ">", ">gv", { desc = "Indent right and reselect" })

-- Save only if there are changes
map("n", "<C-s>", "<cmd>update<cr>", { desc = "Save file" })
map("v", "<C-s>", "<cmd>update<cr>", { desc = "Save file" })
map("i", "<C-s>", "<C-o>:update<CR>", { desc = "Save file" })

map("n", "<M-Esc>", "<cmd>noh<CR>", { desc = "Clear highlights" })

map("t", "<C-q>", "<C-\\><C-N>", { desc = "Escape terminal mode" })

-- Comment
map("n", "<C-_>", "gcc", { desc = "toggle comment", remap = true })
map("v", "<C-_>", "gc", { desc = "toggle comment", remap = true })
map("i", "<C-_>", "<Esc>gccA", { desc = "toggle comment", remap = true })

-- Jump last and first char of the line
map({ "n", "v" }, "!", "0", { desc = "Jump to first non-blank character of the line" })
map({ "n", "v" }, "@", "$", { desc = "Jump to last non-blank character of line" })
map({ "n", "v" }, "<C-S-Left>", "^", { desc = "Jump to first non-blank character of the line" })
map({ "n", "v" }, "<C-S-Right>", "g_", { desc = "Jump to last non-blank character of line" })

--------------------------------------------------------
-- Toggle
map("n", "<leader>tw", function()
  vim.wo.wrap = not vim.wo.wrap
end, { desc = "Toggle line wrapping" })

map("n", "<leader>tm", function()
  require("render-markdown").toggle()
end, { desc = "Toggle render-markdown" })

--------------------------------------------------------
-- Nice
map("n", "<C-c>", "<cmd>%y+<CR>", { desc = "Copy whole file" })
map("n", "<C-a>", "ggVG", { desc = "Select all" })

--------------------------------------------------------
-- Tabs
map("n", "tn", "<cmd>tabnew<CR>", { desc = "New tab" })
map("n", "tQ", "<cmd>tabonly<CR>", { desc = "Close all other tabs" })
map("n", "tq", "<cmd>tabclose<CR>", { desc = "Close tab" })

map("n", "t<Right>", "<cmd>tabnext<CR>", { desc = "Next tab" })
map("n", "t<Left>", "<cmd>tabprevious<CR>", { desc = "Previous tab" })

local function smart_tab(forward)
  if vim.v.hlsearch == 1 and vim.fn.getreg("/") ~= "" then
    return forward and "n" or "N"
  else
    return forward and "<cmd>tabnext<CR>" or "<cmd>tabprevious<CR>"
  end
end

map("n", "<Tab>", function()
  return smart_tab(true)
end, { expr = true, desc = "Next search match or Next Tab" })
map("n", "<S-Tab>", function()
  return smart_tab(false)
end, { expr = true, desc = "Prev search match or Prev Tab" })

--------------------------------------------------------

-- Window related stuff
map({ "n", "v" }, "<C-w><S-Left>", function()
  vim.cmd("wincmd H")
end, { desc = "Move window to the far left" })
map({ "n", "v" }, "<C-w><S-Right>", function()
  vim.cmd("wincmd L")
end, { desc = "Move window to the far left" })
map({ "n", "v" }, "<C-w><S-Down>", function()
  vim.cmd("wincmd J")
end, { desc = "Move window to the far left" })
map({ "n", "v" }, "<C-w><S-Up>", function()
  vim.cmd("wincmd K")
end, { desc = "Move window to the far left" })

map({ "n", "v" }, "<S-M-Down>", ":resize +2<CR>", { desc = "Increase window height" })
map({ "n", "v" }, "<S-M-Up>", ":resize -2<CR>", { desc = "Decrease window height" })
map({ "n", "v" }, "<S-M-Right>", ":vertical resize -2<CR>", { desc = "Decrease window width" })
map({ "n", "v" }, "<S-M-Left>", ":vertical resize +2<CR>", { desc = "Increase window width" })

-- Safe guard
map("n", "<C-W>q", function()
  require("utils.window").close_window_safely()
end, { desc = "Close window safely" })

--------------------------------------------------------
-- Disabled/Change defaults cause why not
--------------------------------------------------------
map("n", "<C-z>", "<nop>", { desc = "Disable suspend" })
map("n", "ZZ", "<nop>", { desc = "Disable accidental save and quit (ZZ)" })
map("n", "ZQ", "<nop>", { desc = "Disable accidental quit (ZQ)" })

map({ "n", "v" }, "s", '"_s', { desc = "Substitute without yanking (visual)" })
map({ "n", "v" }, "S", '"_S', { desc = "Substitute line without yanking (normal)" })

map({ "n", "v" }, "q", "<Nop>", { desc = "Disable recording macro (q)" })
map({ "n", "v" }, "Q", "<Nop>", { desc = "Disable Ex mode (Q)" })

map("v", "p", '"_dP', { desc = "Paste without yanking replaced text" })
map({ "n", "v" }, "c", '"_c', { desc = "Change text without yanking" })
map({ "n", "v" }, "C", '"_C', { desc = "Change to end of line without yanking" })

map({ "n", "v" }, "d", '"_d', { desc = "Delete without yanking" })
map({ "n", "v" }, "D", '"_D', { desc = "Delete to end of line without yanking" })

-- what the fuck am I doing?
map("n", "X", "D", { desc = "Cut line" })
map("n", "xx", "dd", { desc = "Cut line" })
map("n", "x", "d", { desc = "Cut line" })

-- Highlights the word without jumping to the next occurrence.
-- Uses case-insensitive search and enables 'hlsearch'.
map(
  "n",
  "#",
  [[<Cmd>let @/ = '\c\<'.expand('<cword>').'\>'<CR>:set hlsearch<CR>]],
  { desc = "Highlight word (no jump, case-insensitive)" }
)
map(
  "v",
  "#",
  [[y<Cmd>let @/ = '\c\V' . escape(@", '/\')<CR>:set hlsearch<CR><Esc>]],
  { desc = "Highlight selection (no jump, case-insensitive)" }
)
