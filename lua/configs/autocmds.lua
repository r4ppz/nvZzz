local mygroup = vim.api.nvim_create_augroup("MyPersonalConfig", { clear = true })
local autocmd = vim.api.nvim_create_autocmd
local map = require("utils.map")

autocmd("FileType", {
  group = mygroup,
  desc = "Better quickfix and location list configuration",
  pattern = "qf",
  callback = function(args)
    map("n", "q", "<cmd>close<cr>", { buffer = args.buf })
    vim.opt_local.statusline = ""
    vim.opt_local.number = false
  end,
})

autocmd("FileType", {
  group = mygroup,
  desc = "Close window with q",
  pattern = { "help", "gitsigns-blame" },
  callback = function()
    map("n", "q", "<cmd>close<cr>", { buffer = true })
  end,
})

autocmd("TermOpen", {
  group = mygroup,
  desc = "Keep the state of snacks lazygit (toggleble)",
  pattern = "*",
  callback = function()
    local term_title = vim.b.term_title
    if term_title and term_title:match("lazygit") then
      map("t", { "<M-g>", "q" }, "<cmd>close<cr>", { buffer = true })
    end
  end,
})

autocmd({
  "BufEnter",
  "CursorHold",
  "CursorHoldI",
  "FocusGained",
}, {
  group = mygroup,
  desc = "Check for file changes when entering buffer or regaining focus",
  callback = function()
    if vim.fn.getcmdwintype() == "" then
      vim.cmd("checktime")
    end
  end,
})

autocmd({ "FileType", "BufEnter" }, {
  group = mygroup,
  pattern = { "copilot-chat" },
  callback = function()
    vim.opt_local.relativenumber = false
    vim.opt_local.number = false
    vim.opt_local.conceallevel = 0
  end,
})

autocmd("BufReadPost", {
  group = mygroup,
  pattern = { "*.png", "*.jpg", "*.jpeg", "*.webp", "*.gif", "*.bmp", "*.svg" },
  desc = "Open images in imv and close buffer automatically",
  callback = function(args)
    vim.fn.jobstart({ "imv", args.file }, { detach = true })

    vim.schedule(function()
      if vim.api.nvim_buf_is_valid(args.buf) then
        vim.api.nvim_buf_delete(args.buf, { force = true })
      end
    end)
  end,
})

autocmd("BufReadPost", {
  group = mygroup,
  pattern = { "*.pdf", "*.epub" },
  desc = "Open PDF/EPUB files in Okular and close buffer automatically",
  callback = function(args)
    vim.fn.jobstart({ "okular", args.file }, { detach = true })
    vim.schedule(function()
      if vim.api.nvim_buf_is_valid(args.buf) then
        vim.api.nvim_buf_delete(args.buf, { force = true })
      end
    end)
  end,
})

autocmd("FileType", {
  group = mygroup,
  desc = "Enable wrapping on text",
  pattern = { "text" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.breakindent = true
  end,
})

autocmd("TextYankPost", {
  group = mygroup,
  desc = "Highlight when yanking (copying) text",
  callback = function()
    vim.hl.on_yank()
  end,
})
