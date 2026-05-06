local custom_hover = require("configs.hover")
local map = require("utils.map")

--------------------------------------------------
-- LSP related

-- Double-tap logic for native hover
local HOVER_DOUBLE_TAP_MS = 300
local last_hover_time = 0
local function hover_with_enter()
  local now = vim.loop.now()
  if now - last_hover_time < HOVER_DOUBLE_TAP_MS then
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      local config = vim.api.nvim_win_get_config(win)
      if config and type(config.relative) == "string" and config.relative ~= "" then
        vim.api.nvim_set_current_win(win)
        return
      end
    end
  else
    custom_hover.open_hover()
    last_hover_time = now
  end
end

map("n", "K", hover_with_enter, { desc = "Custom Hover" })
map("n", "<S-C-Up>", hover_with_enter, { desc = "Custom Hover" })

map({ "n", "x", "o" }, "<CR>", function()
  if vim.treesitter.get_parser(nil, nil, { error = false }) then
    require("vim.treesitter._select").select_parent(vim.v.count1)
  else
    vim.lsp.buf.selection_range(vim.v.count1)
  end
end, { desc = "Select parent treesitter node or outer incremental lsp selections" })

map({ "n", "x", "o" }, "<BS>", function()
  if vim.treesitter.get_parser(nil, nil, { error = false }) then
    require("vim.treesitter._select").select_child(vim.v.count1)
  else
    vim.lsp.buf.selection_range(-vim.v.count1)
  end
end, { desc = "Select child treesitter node or inner incremental lsp selections" })

map("n", "<leader>Lr", "<cmd>lsp restart<cr>", { desc = "Restart LSP" })
map("n", "<leader>Li", "<cmd>checkhealth vim.lsp<cr>", { desc = "LSP Info" })
map("n", "<leader>Ls", "<cmd>lsp stop<cr>", { desc = "LSP Stop" })

map("n", "gR", "<cmd>Lspsaga finder ref+def+imp<CR>", {
  desc = "Find References (including def and imp)",
})

map("n", "gr", function()
  Snacks.picker.lsp_references({
    auto_confirm = false,
    title = "References",
    layout = {
      layout = {
        box = "vertical",
        row = -1,
        width = 0,
        height = 0.5,
        border = "top",
        {
          box = "horizontal",
          {
            win = "list",
            border = "none",
          },
          {
            win = "preview",
            title = "{preview}",
            width = 0.5,
            border = "left",
          },
        },
      },
    },
  })
end, { desc = "LSP References (Snacks)" })

map("n", "gd", function()
  Snacks.picker.lsp_definitions()
end, { desc = "Goto [d]efinition (Snacks)" })

map("n", "gi", function()
  Snacks.picker.lsp_implementations()
end, { desc = "Goto [I]mplementation (Snacks)" })

map("n", "gy", function()
  Snacks.picker.lsp_type_definitions()
end, { desc = "Goto T[y]pe Definition (Snacks)" })

map("n", "ge", function()
  Snacks.picker.lsp_declarations()
end, { desc = "Goto D[e]claration (Snacks)" })

map("n", { "gD", "<S-C-Down>" }, function()
  require("lspeek").peek_definition()
end, {
  desc = "Peek Definition (lspeek)",
})

map("n", "gT", "<cmd>Lspsaga peek_type_definition<CR>", {
  desc = "Peek Type Definition",
})

map({ "n", "v" }, "<leader>la", "<cmd>Lspsaga code_action<CR>", {
  desc = "Code Actions",
})

map("n", "<leader>lr", "<cmd>Lspsaga rename<CR>", {
  desc = "Rename Symbol",
})

-- Diagnostic Show
map("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", {
  desc = "Previous Diagnostic",
})
map("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", {
  desc = "Next Diagnostic",
})

map("n", "<leader>lD", "<cmd>Lspsaga show_line_diagnostics<CR>", {
  desc = "Show Line Diagnostics",
})
map("n", "<leader>ld", "<cmd>Lspsaga show_buf_diagnostics<CR>", {
  desc = "Show Buffer Diagnostics",
})
map("n", "<leader>lw", "<cmd>Lspsaga show_workspace_diagnostics<CR>", {
  desc = "Show Workspace Diagnostics",
})

map("n", "<leader>li", function()
  Snacks.picker.lsp_incoming_calls({
    auto_confirm = false,
    title = "References",
    layout = {
      preview = "main",
      layout = {
        backdrop = false,
        width = 40,
        min_width = 40,
        height = 0,
        position = "right",
        border = "none",
        box = "vertical",
        { win = "list", border = "none" },
        { win = "preview", title = "{preview}", height = 0.4, border = "top" },
      },
    },
  })
end, {
  desc = "Incoming Calls",
})

map("n", "<leader>lo", function()
  Snacks.picker.lsp_outgoing_calls({
    auto_confirm = false,
    title = "References",
    layout = {
      preview = "main",
      layout = {
        backdrop = false,
        width = 40,
        min_width = 40,
        height = 0,
        position = "right",
        border = "none",
        box = "vertical",
        { win = "list", border = "none" },
        { win = "preview", title = "{preview}", height = 0.4, border = "top" },
      },
    },
  })
end, {
  desc = "Outgoing Calls",
})

map("n", "<leader>ls", function()
  require("utils.window").toggle_panel(function()
    require("outline").toggle()
  end, "Outline")
end, { desc = "Toggle Outline" })

--Track the toggle state
local diagnostics_visible = false
map("n", "<leader>Ld", function()
  diagnostics_visible = not diagnostics_visible

  vim.diagnostic.config({
    signs = diagnostics_visible,
    underline = diagnostics_visible,

    -- Ensure defaults
    virtual_text = false,
    update_in_insert = false,
  })

  -- Feedback
  if diagnostics_visible then
    print("Diagnostics Enabled (Signs/Underline)")
  else
    print("Diagnostics Silenced")
  end
end, { desc = "Toggle Diagnostic UI elements" })
