local M = {}

-- Filetypes that should not be open at the same time
local SIDE_PANEL_FTS = {
  "copilot-chat",
  "Outline",
  "terminal",
  "NvTerm_sp",
  "NvTerm_vsp",
  "NvTerm_float",
  "spectre_panel",
}

local EXCLUDED_FILETYPES = {
  "copilot-chat",
  "NvimTree",
  "neo-tree",
  "Outline",
  "spectre_panel",
}

local EXCLUDED_BUFTYPES = {
  "nofile",
  "prompt",
  "help",
  "quickfix",
  "terminal",
}

--- Checks if a given window is a standard window.
--- A standard window is not relative to another window and is not external.
--- @param win number: The window ID to check.
--- @return boolean: `true` if the window is standard, `false` otherwise.
function M.is_win_standard(win)
  local win_config = vim.api.nvim_win_get_config(win)
  return win_config.relative == "" and not win_config.external
end

--- Determines if a buffer's filetype matches any in the exclusion list.
--- @param buf number: The buffer ID to check.
--- @param exclude_filetypes table<string, boolean>: A set of filetypes to exclude.
--- @return boolean: `true` if the filetype matches any exclusion, `false` otherwise.
function M.is_ft_excluded(buf, exclude_filetypes)
  if not vim.api.nvim_buf_is_valid(buf) then
    return false
  end

  local ft = vim.bo[buf].filetype or ""
  if ft == "" then
    return false
  end

  return vim.tbl_contains(exclude_filetypes, ft)
end

--- Determines if a buffer's buftype matches any in the exclusion list.
--- @param buf number: The buffer ID to check.
--- @param exclude_buftypes table<string, boolean>: A set of buftypes to exclude.
--- @return boolean: `true` if the buftype matches any exclusion, `false` otherwise.
function M.is_bt_excluded(buf, exclude_buftypes)
  if not vim.api.nvim_buf_is_valid(buf) then
    return false
  end

  local bt = vim.bo[buf].buftype or ""
  if bt == "" then
    return false
  end

  return vim.tbl_contains(exclude_buftypes, bt)
end

--- Checks if a window and its buffer represent a main editing window (not a sidebar, terminal, or special buffer).
--- @param win number: The window ID to check.
--- @param buf number: The buffer ID to check.
--- @return boolean: `true` if it's a main editing window.
function M.is_main_editing_window(win, buf)
  if not M.is_win_standard(win) then
    return false
  end

  if M.is_bt_excluded(buf, EXCLUDED_BUFTYPES) then
    return false
  end

  if M.is_ft_excluded(buf, EXCLUDED_FILETYPES) then
    return false
  end

  return true
end

--- Validates if a buffer and window are both valid and meet specific conditions.
--- Ensures the buffer and window exist, are not special types, and the window is not in diff mode.
--- @param buf number: The buffer ID to validate.
--- @param win number: The window ID to validate.
--- @return boolean: `true` if both the buffer and window are valid, `false` otherwise.
function M.is_buf_win_valid(buf, win)
  return vim.api.nvim_buf_is_valid(buf)
    and vim.api.nvim_win_is_valid(win)
    and vim.fn.win_gettype(win) == ""
    and vim.bo[buf].buftype == ""
    and not vim.wo[win].diff
end

--- Checks if a buffer is an empty scratch buffer (no name, no buftype).
--- @param buf number: The buffer ID to check.
--- @return boolean: `true` if the buffer is an empty scratch buffer.
function M.is_empty_scratch_buf(buf)
  return vim.api.nvim_buf_get_name(buf) == "" and vim.bo[buf].buftype == ""
end

--- Wraps an action to ensure it is executed only in a standard buffer.
--- Skips execution if the window is relative or the buffer's filetype is excluded.
--- @param action function: The function to execute safely.
--- @return function: A wrapped function that performs the safety checks.
function M.safe_buf_action(action)
  return function()
    if not M.is_win_standard(0) then
      return
    end

    if M.is_ft_excluded(0, EXCLUDED_FILETYPES) then
      return
    end

    pcall(action)
  end
end

--- Focuses the main window in the current tabpage.
--- If the current window is a sidebar or terminal,
--- switches to the first standard window.
function M.focus_main_window()
  local current_win = vim.api.nvim_get_current_win()
  local current_buf = vim.api.nvim_get_current_buf()

  if M.is_main_editing_window(current_win, current_buf) then
    return
  end

  local wins = vim.api.nvim_tabpage_list_wins(0)
  for _, w in ipairs(wins) do
    local b = vim.api.nvim_win_get_buf(w)
    if M.is_main_editing_window(w, b) then
      vim.api.nvim_set_current_win(w)
      return
    end
  end
end

--- Closes all side panel windows in the current tabpage.
--- This function iterates through all windows in the current tabpage and checks
--- if their filetype matches any in the predefined `side_panel_fts` list. If a
--- match is found, the window is forcefully closed.
function M.close_panels()
  local wins = vim.api.nvim_tabpage_list_wins(0)
  for _, win in ipairs(wins) do
    local buf = vim.api.nvim_win_get_buf(win)

    if M.is_ft_excluded(buf, SIDE_PANEL_FTS) then
      vim.api.nvim_win_close(win, true)
    end
  end
end

--- Closes other side panels (if target is not already open) then runs the toggle.
--- @param toggle_fn function: The toggle function to run.
--- @param panel_ft string: The filetype of the panel this toggle opens (e.g. "copilot-chat", "Outline").
function M.toggle_panel(toggle_fn, panel_ft)
  -- Check if this panel is already open
  local already_open = false
  local wins = vim.api.nvim_tabpage_list_wins(0)
  for _, win in ipairs(wins) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].filetype == panel_ft then
      already_open = true
      break
    end
  end

  -- Only close other side panels when opening, not when closing
  if not already_open then
    M.close_panels()
  end

  toggle_fn()
end

--- Closes the current window safely.
--- Prevents closing the last standard window in the last tabpage,
--- but allows closing floating windows, special buffers, or tabs.
function M.close_window_safely()
  local win = vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_win_get_buf(win)

  -- Always allow closing non-main windows (floating, special buffers, sidebars)
  if not M.is_main_editing_window(win, buf) then
    vim.cmd("q")
    return
  end

  -- Count "real" windows in the current tab
  local normal_wins = 0
  for _, w in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local b = vim.api.nvim_win_get_buf(w)
    if M.is_main_editing_window(w, b) then
      normal_wins = normal_wins + 1
    end
  end

  local total_tabs = #vim.api.nvim_list_tabpages()

  if normal_wins > 1 or total_tabs > 1 then
    vim.cmd("q")
  else
    vim.notify("Cannot close the last window", vim.log.levels.WARN)
  end
end

return M
