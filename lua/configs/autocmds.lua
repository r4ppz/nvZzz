local mygroup = vim.api.nvim_create_augroup("MyPersonalConfig", { clear = true })
local autocmd = vim.api.nvim_create_autocmd

autocmd({ "FileType", "BufEnter" }, {
  group = mygroup,
  pattern = { "copilot-chat", "spectre_panel" },
  callback = function()
    vim.opt_local.relativenumber = false
    vim.opt_local.number = false
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
