local M = {}

--- Maps a key to close a terminal window by toggling its visibility.
--- Note: only works on NvChad terminal. Mappings are buffer-local.
--- @param config table: The full toggle config (must include `id`)
--- @param extra_key string? # Optional extra key to also close (e.g. "q" ).
function M.map_close_terminal(config, extra_key)
  local map = vim.keymap.set
  -- Default
  map("t", "<M-q>", function()
    require("nvchad.term").toggle(config)
  end, { buffer = 0 })

  -- Optionally add an extra close key
  if extra_key then
    map("t", extra_key, function()
      require("nvchad.term").toggle(config)
    end, { buffer = 0 })
  end
end

-- Filetypes that should not be open at the same time
local side_panel_fts = {
  "copilot-chat",
  "Outline",
  "terminal",
  "NvTerm_sp",
  "NvTerm_vsp",
  "NvTerm_float",
  "help",
}

--- Closes all side panel windows in the current tabpage.
--- This function iterates through all windows in the current tabpage and checks
--- if their filetype matches any in the predefined `side_panel_fts` list. If a
--- match is found, the window is forcefully closed.
function M.close_existing_side_panels_first()
  local wins = vim.api.nvim_tabpage_list_wins(0)
  for _, win in ipairs(wins) do
    local buf = vim.api.nvim_win_get_buf(win)
    local ft = vim.bo[buf].filetype

    -- Check if the window's filetype is in our restricted list
    for _, panel_ft in ipairs(side_panel_fts) do
      if ft == panel_ft then
        vim.api.nvim_win_close(win, true)
        break
      end
    end
  end
end

local excluded_filetypes = {
  "copilot-chat",
  "NvimTree",
  "neo-tree",
  "Outline",
}

--- Wraps an action to ensure it is executed only in a standard buffer.
--- Skips execution if the window is relative or the buffer's filetype is excluded.
--- @param action function: The function to execute safely.
--- @return function: A wrapped function that performs the safety checks.
function M.safe_buf_action(action)
  return function()
    if not M.is_win_standard(0) then
      return
    end

    if M.is_ft_excluded(0, excluded_filetypes) then
      return
    end

    pcall(action)
  end
end

--- Focuses the main window in the current tabpage.
--- If the current window is a sidebar or terminal,
--- switches to the first standard window.
function M.focus_main_window()
  local current_buf = vim.api.nvim_get_current_buf()
  local is_sidebar = vim.tbl_contains(excluded_filetypes, vim.bo[current_buf].filetype)
  local is_term = vim.bo[current_buf].buftype == "terminal"

  if is_sidebar or is_term then
    local wins = vim.api.nvim_tabpage_list_wins(0)
    for _, w in ipairs(wins) do
      local b = vim.api.nvim_win_get_buf(w)
      local ft = vim.bo[b].filetype
      local bt = vim.bo[b].buftype

      if not vim.tbl_contains(excluded_filetypes, ft) and bt ~= "terminal" and bt ~= "nofile" then
        vim.api.nvim_set_current_win(w)
        return
      end
    end
  end
end

--- Closes other side panels (if target is not already open) then runs the toggle.
--- @param toggle_fn function: The toggle function to run.
--- @param panel_ft string: The filetype of the panel this toggle opens (e.g. "copilot-chat", "Outline").
function M.close_other_panels_and_toggle(toggle_fn, panel_ft)
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
    M.close_existing_side_panels_first()
  end

  toggle_fn()
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

--- Checks if a given window is a standard window.
--- A standard window is not relative to another window and is not external.
--- @param win number: The window ID to check.
--- @return boolean: `true` if the window is standard, `false` otherwise.
function M.is_win_standard(win)
  local win_config = vim.api.nvim_win_get_config(win)
  return win_config.relative == "" and not win_config.external
end

--- Checks if a buffer is an empty scratch buffer (no name, no buftype).
--- @param buf number: The buffer ID to check.
--- @return boolean: `true` if the buffer is an empty scratch buffer.
function M.is_empty_scratch_buf(buf)
  return vim.api.nvim_buf_get_name(buf) == "" and vim.bo[buf].buftype == ""
end

--- Determines if a buffer's filetype matches any in the exclusion list.
--- Splits the filetype by dots and checks each part against the list.
--- @param buf number: The buffer ID to check.
--- @param exclude_filetypes string[]: A list of filetypes to exclude.
--- @return boolean: `true` if the filetype matches any exclusion, `false` otherwise.
function M.is_ft_excluded(buf, exclude_filetypes)
  local ft = vim.bo[buf].filetype or ""
  ft = ft:lower()
  if ft == "" then
    return false
  end

  local parts = vim.split(ft, "%.", { plain = false })
  for _, part in ipairs(parts) do
    for _, ex in ipairs(exclude_filetypes) do
      if part == ex:lower() then
        return true
      end
    end
  end
  return false
end

return M
