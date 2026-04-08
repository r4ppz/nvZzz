local map = vim.keymap.set

--------------------------------------------------------
-- Personal?!
--------------------------------------------------------

map({ "n", "v" }, "<leader>ob", "<cmd>BufInfo<CR>", {
  desc = "Get BufInfo",
})
map("n", "<leader>ow", function()
  vim.wo.wrap = not vim.wo.wrap
end, { desc = "Toggle line wrapping" })

map("n", "<C-W>q", function()
  if vim.fn.winnr("$") > 1 then
    vim.cmd("q")
  else
    vim.notify("Cannot close the last window", vim.log.levels.WARN)
  end
end, { desc = "Close window safely" })

map("n", "<C-A-Up>", ":m .-2<CR>==<C-l>", { desc = "Move line up" })
map("n", "<C-A-Down>", ":m .+1<CR>==<C-l>", { desc = "Move line down" })
map("v", "<C-A-Up>", ":m '<-2<CR>gv=gv<C-l>", { desc = "Move selection up" })
map("v", "<C-A-Down>", ":m '>+1<CR>gv=gv<C-l>", { desc = "Move selection down" })
map("i", "<C-A-Up>", "<Esc>:m .-2<CR>==gi<C-o><C-l>", { desc = "Move selection up" })
map("i", "<C-A-Down>", "<Esc>:m .+1<CR>==gi<C-o><C-l>", { desc = "Move selection up" })

map("n", "<C-c>", "<cmd>%y+<CR>", { desc = "Copy whole file" })

-- Insert below and above
map("n", "<M-Up>", "O", { desc = "Insert above" })
map("n", "<M-Down>", "o", { desc = "Insert below" })
map("i", "<M-Up>", "<C-o>O", { desc = "Insert above" })
map("i", "<M-Down>", "<C-o>o", { desc = "Insert below" })

-- Undo and redo
map("n", "<M-a>", "u", { desc = "Undo" })
map("i", "<M-a>", "<C-o>u", { desc = "Undo (Insert)" })
map("v", "<M-a>", "u", { desc = "Undo (Visual)" })
map("n", "<M-d>", "<C-r>", { desc = "Redo" })
map("i", "<M-d>", "<C-o><C-r>", { desc = "Redo (Insert)" })
map("v", "<M-d>", "<C-r>", { desc = "Redo (Visual)" })

-- Scroll half page and center
map("n", "<S-Up>", "<C-u>zz", { desc = "Scroll half a page up and center" })
map("n", "<S-Down>", "<C-d>zz", { desc = "Scroll half a page down and center" })
map("i", "<S-Up>", "<C-o><C-u><C-o>zz", { desc = "Scroll half a page up and center in insert mode" })
map("i", "<S-Down>", "<C-o><C-d><C-o>zz", { desc = "Scroll half a page down and center in insert mode" })

-- Ctrl+Left and Right (like VSCode)
map({ "n", "v" }, "<C-Left>", "b", { desc = "Move to the beginning of the word" })
map({ "n", "v" }, "<C-Right>", "e", { desc = "Move to the end of the word" })
map("i", "<C-Left>", "<C-o>b", { desc = "Move to the beginning of the word in insert mode" })
map("i", "<C-Right>", "<C-o>e", { desc = "Move to the end of the word in insert mode" })

-- Same but with Shift
map({ "n", "v" }, "<S-Right>", "W", { desc = "Move Right like E" })
map({ "n", "v" }, "<S-Left>", "B", { desc = "Move Left like B" })

map("v", "<S-Up>", "{", { desc = "Jump to previous paragraph" })
map("v", "<S-Down>", "}", { desc = "Jump to next paragraph" })

-- Ctrl+Up and Down like (like VSCode)
map({ "n", "v" }, "<C-Down>", "<C-e>", { desc = "Scroll window down one line" })
map({ "n", "v" }, "<C-Up>", "<C-y>", { desc = "Scroll window up one line" })
map("i", "<C-Down>", "<C-o><C-e>", { desc = "Scroll window down one line in insert mode" })
map("i", "<C-Up>", "<C-o><C-y>", { desc = "Scroll window up one line in insert mode" })

map("v", "<", "<gv", { desc = "Indent left and reselect" })
map("v", ">", ">gv", { desc = "Indent right and reselect" })

-- Save only if there are changes (like VSCode)
map("n", "<C-s>", "<cmd>update<cr>", { desc = "Save file" })
map("v", "<C-s>", "<cmd>update<cr>", { desc = "Save file" })
map("i", "<C-s>", "<C-o>:update<CR>", { desc = "Save file" })

map("n", "<M-Esc>", "<cmd>noh<CR>", { desc = "Clear highlights" })

map("t", "<C-q>", "<C-\\><C-N>", { desc = "Escape terminal mode" })

-- Comment
map("n", "<leader>/", "gcc", { desc = "toggle comment", remap = true })
map("v", "<leader>/", "gc", { desc = "toggle comment", remap = true })

map({ "n", "v" }, "!", "^", { desc = "Jump to first non-blank character of the line" })
map({ "n", "v" }, "@", "g_", { desc = "Jump to last non-blank character of line" })

--------------------------------------------------
-- Disabled/Change defaults cause why not
--------------------------------------------------
map("n", "<C-r>", "<nop>", { desc = "Disable redo" })
map("n", "u", "<nop>", { desc = "Disable undo" })

map("n", "<C-z>", "<nop>", { desc = "Disable suspend" })
map("n", "ZZ", "<nop>", { desc = "Disable accidental save and quit (ZZ)" })
map("n", "ZQ", "<nop>", { desc = "Disable accidental quit (ZQ)" })

map("n", "s", "<nop>", { desc = "Disable s to avoid accidental edits" })
map("v", "s", '"_s', { desc = "Substitute without yanking (visual)" })
map("n", "S", '"_S', { desc = "Substitute line without yanking (normal)" })

map({ "n", "v" }, "q", "<Nop>", { desc = "Disable recording macro (q)" })
map({ "n", "v" }, "Q", "<Nop>", { desc = "Disable Ex mode (Q)" })

map("v", "p", '"_dP', { desc = "Paste without yanking replaced text" })
map({ "n", "v" }, "x", '"_x', { desc = "Delete character without yanking" })
map("n", "c", '"_c', { desc = "Change text without yanking" })
-- keymap.map("n", "d", '"_d', { desc = "Delete text without yanking" })

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

--------------------------------------------------
-- Tabs
map("n", "<leader>tn", "<cmd>tabnew<CR>", { desc = "New tab" })
map("n", "<leader>tQ", "<cmd>tabonly<CR>", { desc = "Close all other tabs" })
map("n", "<leader>tq", "<cmd>tabclose<CR>", { desc = "Close tab" })

map("n", "<Tab>", "<cmd>tabnext<CR>", { desc = "Next tab" })
map("n", "<S-Tab>", "<cmd>tabprevious<CR>", { desc = "Previous tab" })

map("n", "<leader>t<Right>", "<cmd>tabnext<CR>", { desc = "Next tab" })
map("n", "<leader>t<Left>", "<cmd>tabprevious<CR>", { desc = "Previous tab" })

map("n", "]t", "<cmd>tabnext<CR>", { desc = "Next tab" })
map("n", "[t", "<cmd>tabprevious<CR>", { desc = "Previous tab" })

--------------------------------------------------

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
