local function set_highlights()
  vim.api.nvim_set_hl(0, "LspReferenceText", { underline = true, bg = "none" })
  vim.api.nvim_set_hl(0, "LspReferenceRead", { underline = true, bg = "none" })
  vim.api.nvim_set_hl(0, "LspReferenceWrite", { underline = true, bg = "none" })

  vim.api.nvim_set_hl(0, "MatchParen", {
    fg = "#83A598",
    bg = "#444444",
  })

  vim.api.nvim_set_hl(0, "MatchParenCur", {
    fg = "#83A598",
    bg = "#444444",
  })

  vim.api.nvim_set_hl(0, "MatchWord", {
    fg = "",
    bg = "#444444",
  })

  vim.api.nvim_set_hl(0, "MatchWordCur", {
    fg = "",
    bg = "#444444",
  })

  vim.api.nvim_set_hl(0, "NormalFloat", { link = "Normal" })
  vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#4F4F4F" })

  vim.api.nvim_set_hl(0, "NvimDapVirtualText", { fg = "#56b6c2", italic = true })
  vim.api.nvim_set_hl(0, "NvimDapVirtualTextChanged", { fg = "#d19a66" })
  vim.api.nvim_set_hl(0, "NvimDapVirtualTextError", { link = "ErrorMsg" })

  vim.api.nvim_set_hl(0, "DapBreakpoint", { fg = "#e51400", bg = "NONE" })
  vim.api.nvim_set_hl(0, "DapBreakpointCondition", { fg = "#f5a623", bg = "NONE" })
  vim.api.nvim_set_hl(0, "DapBreakpointRejected", { fg = "#888888", bg = "NONE" })
  vim.api.nvim_set_hl(0, "DapLogPoint", { fg = "#61afef", bg = "NONE" })
  vim.api.nvim_set_hl(0, "DapStopped", { fg = "#98c379", bg = "NONE" })
  vim.api.nvim_set_hl(0, "DapStoppedLine", { bg = "#2a2d3e" })
end

vim.api.nvim_create_autocmd("User", {
  pattern = "NvThemeReload",
  callback = set_highlights,
})

set_highlights()
