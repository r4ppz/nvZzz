local map = require("utils.map")
local layout = require("utils.layout")

-- LSP-dependent mappings
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("LspMappings", { clear = true }),
  callback = function(args)
    local buf = args.buf

    map("n", { "<S-C-Up>", "K" }, function()
      require("configs.hover").hover({
        max_width = 80,
        max_height = 15,
        border = "single",
      })
    end, { buffer = buf, desc = "Hover" })

    map("n", "<leader>lr", function()
      require("configs.rename").rename()
    end, {
      buffer = buf,
      desc = "Rename Symbol",
    })

    map("n", "gR", function()
      require("trouble").toggle({ mode = "lsp_references", source = "lsp.references" })
    end, {
      buffer = buf,
      desc = "Find References (Trouble)",
    })

    map("n", "gr", function()
      Snacks.picker.lsp_references({
        auto_confirm = false,
        title = "References",
        layout = layout.references,
      })
    end, { buffer = buf, desc = "LSP References (Snacks)" })

    map("n", "gd", function()
      Snacks.picker.lsp_definitions()
    end, { buffer = buf, desc = "Goto [d]efinition (Snacks)" })

    map("n", "gi", function()
      Snacks.picker.lsp_implementations()
    end, { buffer = buf, desc = "Goto [I]mplementation (Snacks)" })

    map("n", "gy", function()
      Snacks.picker.lsp_type_definitions()
    end, { buffer = buf, desc = "Goto T[y]pe Definition (Snacks)" })

    map("n", "ge", function()
      Snacks.picker.lsp_declarations()
    end, { buffer = buf, desc = "Goto D[e]claration (Snacks)" })

    map("n", { "gD", "<S-C-Down>" }, function()
      require("lspeek").peek_definition()
    end, {
      buffer = buf,
      desc = "Peek Definition (lspeek)",
    })

    map("n", { "gT" }, function()
      require("lspeek").peek_type_definition()
    end, {
      buffer = buf,
      desc = "Peek Definition (lspeek)",
    })

    map({ "n", "v" }, "<leader>la", function()
      vim.lsp.buf.code_action()
    end, {
      buffer = buf,
      desc = "Code Actions",
    })

    map("n", "<leader>li", function()
      Snacks.picker.lsp_incoming_calls({
        auto_confirm = false,
        title = "References",
        layout = layout.side,
      })
    end, {
      buffer = buf,
      desc = "Incoming Calls",
    })

    map("n", "<leader>lo", function()
      Snacks.picker.lsp_outgoing_calls({
        auto_confirm = false,
        title = "References",
        layout = layout.side,
      })
    end, {
      buffer = buf,
      desc = "Outgoing Calls",
    })
  end,
})

map("n", "<leader>Lr", "<cmd>lsp restart<cr>", { desc = "Restart LSP" })
map("n", "<leader>Li", "<cmd>checkhealth vim.lsp<cr>", { desc = "LSP Info" })
map("n", "<leader>Ls", "<cmd>lsp stop<cr>", { desc = "LSP Stop" })

-- Diagnostic navigation
map("n", "[d", function()
  vim.diagnostic.jump({ count = -1, float = true })
end, { desc = "Go to previous diagnostic" })
map("n", "]d", function()
  vim.diagnostic.jump({ count = 1, float = true })
end, { desc = "Go to next diagnostic" })

map("n", "<leader>ld", function()
  require("trouble").toggle({
    mode = "diagnostics",
    filter = { buf = 0 },
    source = "diagnostics",
  })
end, {
  desc = "Buffer Diagnostics (Trouble)",
})
map("n", "<leader>lD", function()
  require("trouble").toggle({
    mode = "diagnostics",
    source = "diagnostics",
  })
end, {
  desc = "Workspace Diagnostics (Trouble)",
})

map("n", "<leader>ls", function()
  require("utils.window").toggle_panel(function()
    require("outline").toggle()
  end, "Outline")
end, { desc = "Toggle Outline Symbol" })

local diagnostics_visible = false

-- Icon map once
local diagnostic_icons = {
  [vim.diagnostic.severity.ERROR] = " ",
  [vim.diagnostic.severity.WARN] = " ",
  [vim.diagnostic.severity.INFO] = " ",
  [vim.diagnostic.severity.HINT] = " ",
}

map("n", "<leader>Ld", function()
  diagnostics_visible = not diagnostics_visible

  vim.diagnostic.config({
    -- When true, passes the icon table; when false, disables signs completely
    signs = diagnostics_visible and { text = diagnostic_icons } or false,
    underline = diagnostics_visible,

    virtual_text = false,
    update_in_insert = false,
  })

  if diagnostics_visible then
    print("Diagnostics Enabled (Icons/Underline)")
  else
    print("Diagnostics Silenced")
  end
end, { desc = "Toggle Diagnostic UI elements" })

-- Check LSP selection range support
local function supports_selection_range()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  for _, client in ipairs(clients) do
    if client:supports_method("textDocument/selectionRange") then
      return true
    end
  end
  return false
end

-- Expand/contract selection via treesitter or LSP
local function handle_incremental_selection(is_expanding)
  local count = vim.v.count1
  local parser = vim.treesitter.get_parser()

  if parser then
    if is_expanding then
      require("vim.treesitter._select").select_parent(count)
    else
      require("vim.treesitter._select").select_child(count)
    end
  elseif supports_selection_range() then
    local amt = is_expanding and count or -count
    vim.lsp.buf.selection_range(amt)
  end
end

map("n", "<CR>", function()
  local col = vim.fn.col(".")
  local char = vim.fn.getline("."):sub(col, col)
  if char:match("[%w_]") then
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("viw", true, false, true), "n", true)
  else
    vim.cmd("normal! v")
    handle_incremental_selection(true)
  end
end, { desc = "Select word or expand selection" })

map({ "x", "o" }, "<CR>", function()
  handle_incremental_selection(true)
end, { desc = "Select parent treesitter node or LSP selection" })
map({ "x", "o" }, "<BS>", function()
  handle_incremental_selection(false)
end, { desc = "Select child treesitter node or LSP selection" })

-- This is pretty convenient lol
map({ "n" }, "<S-CR>", "yiw", { desc = "Yank inner word" })
map({ "v" }, "<S-CR>", "y", { desc = "Yank selection" })
