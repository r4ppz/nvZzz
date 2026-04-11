local win_util = require("utils.window")

local EXCLUDED_FILETYPES = {
  "NvimTree",
  "markdown",
  "gitcommit",
  "diff",
  "Lazy",
  "mason",
  "spectre_panel",
  "copilot-chat",
  "snacks_picker_input",
  "snacks_picker_preview",
  "snacks_picker_list",
  "snacks_dashboard",
}

local function is_valid_source(buf)
  return pcall(vim.treesitter.get_parser, buf)
    or not vim.tbl_isempty(vim.lsp.get_clients({
      bufnr = buf,
      method = "textDocument/documentSymbol",
    }))
end

local function is_enable(buf, win)
  if win_util.is_empty_scratch_buf(buf) then
    if win and vim.api.nvim_win_is_valid(win) then
      vim.wo[win].winbar = ""
    end
    return false
  end

  return not win_util.is_ft_excluded(buf, EXCLUDED_FILETYPES)
    and win_util.is_buf_win_valid(buf, win)
    and win_util.is_win_standard(win)
    and is_valid_source(buf)
end

return {
  "Bekaboo/dropbar.nvim",
  dev = false,
  event = "BufReadPost",
  opts = {
    bar = {
      truncate = false,
      padding = { left = 2, right = 5 },
      enable = is_enable,
    },
    icons = {
      ui = {
        bar = {
          separator = " ",
          extends = "…",
        },
        menu = {
          separator = " ",
          indicator = " ",
        },
      },
    },
  },
  config = function(_, opts)
    require("dropbar").setup(opts)
    local dropbar_api = require("dropbar.api")
    local map = vim.keymap.set
    map("n", "<Leader>;", dropbar_api.pick, { desc = "Pick symbols in winbar" })
    map("n", "[;", dropbar_api.goto_context_start, { desc = "Go to start of current context" })
    map("n", "];", dropbar_api.select_next_context, { desc = "Select next context" })
  end,
}
