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
