local mygroup = vim.api.nvim_create_augroup("MyPersonalConfig", { clear = true })
local autocmd = vim.api.nvim_create_autocmd

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

autocmd("WinEnter", {
  group = mygroup,
  desc = "Auto-close window if only special panel filetype remains",
  callback = function()
    local panels = {
      "copilot-chat",
      "Help",
      "Outline",
    }
    local ft = vim.bo.filetype

    if vim.tbl_contains(panels, ft) and #vim.api.nvim_list_wins() == 1 then
      vim.cmd("quit")
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

autocmd("BufEnter", {
  group = mygroup,
  desc = "Window opts for copilot buffer",
  pattern = "copilot-*",
  callback = function()
    vim.wo.relativenumber = false
    vim.wo.number = false
    vim.wo.conceallevel = 0
    vim.wo.winfixwidth = true
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
