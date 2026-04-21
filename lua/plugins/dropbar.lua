local win_util = require("utils.window")

local EXCLUDED_FILETYPES = {
  "NvimTree",
  "markdown",
  "gitcommit",
  "diff",
  "Lazy",
  "text",
  "mason",
  "spectre_panel",
  "copilot-chat",
  "snacks_picker_input",
  "snacks_picker_preview",
  "snacks_picker_list",
  "snacks_dashboard",
  "none",
  "conf",
}

local function is_valid_source(buf)
  return pcall(vim.treesitter.get_parser, buf)
    or not vim.tbl_isempty(vim.lsp.get_clients({
      bufnr = buf,
      method = "textDocument/documentSymbol",
    }))
end

local function is_enable(buf, win)
  if not win_util.is_buf_win_valid(buf, win) or not win_util.is_win_standard(win) then
    return false
  end

  local ft = vim.bo[buf].filetype
  if ft == "" or win_util.is_ft_excluded(buf, EXCLUDED_FILETYPES) then
    return false
  end

  if win_util.is_empty_scratch_buf(buf) then
    vim.wo[win].winbar = ""
    return false
  end

  return is_valid_source(buf)
end

return {
  "Bekaboo/dropbar.nvim",
  dev = false,
  event = "BufReadPost",
  opts = {
    menu = {
      win_configs = {
        border = "single",
      },
    },

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
