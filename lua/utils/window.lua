local M = {}

local excluded = { "copilot-chat", "NvimTree", "neo-tree", "Outline" }

function M.safe_buf_action(action)
  return function()
    local win_cfg = vim.api.nvim_win_get_config(0)
    if win_cfg.relative ~= "" then
      return
    end

    local ft = vim.bo.filetype

    for _, v in ipairs(excluded) do
      if ft == v then
        return
      end
    end

    pcall(action)
  end
end

function M.focus_main_window()
  local current_buf = vim.api.nvim_get_current_buf()
  local is_sidebar = vim.tbl_contains(excluded, vim.bo[current_buf].filetype)
  local is_term = vim.bo[current_buf].buftype == "terminal"

  if is_sidebar or is_term then
    local wins = vim.api.nvim_tabpage_list_wins(0)
    for _, w in ipairs(wins) do
      local b = vim.api.nvim_win_get_buf(w)
      local ft = vim.bo[b].filetype
      local bt = vim.bo[b].buftype

      if not vim.tbl_contains(excluded, ft) and bt ~= "terminal" and bt ~= "nofile" then
        vim.api.nvim_set_current_win(w)
        return
      end
    end
  end
end

function M.toggle_terminal(config)
  M.focus_main_window()
  require("nvchad.term").toggle(config)
end

function M.map_close_terminal(term_id, buf)
  vim.keymap.set("t", "q", function()
    require("nvchad.term").toggle({ id = term_id })
  end, { buffer = buf })
end

return M
