local map = vim.keymap.set

--------------------------------------------------
-- LSP related

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

map("n", "gD", function()
  require("lspeek").peek_definition()
end, {
  desc = "Peek Definition (Sight)",
})

map("n", "<S-C-Down>", "<cmd>Lspsaga peek_definition<CR>", {
  desc = "Peek Definition (Sight)",
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
