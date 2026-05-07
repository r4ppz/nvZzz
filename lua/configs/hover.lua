local M = {}

local string_utils = require("utils.string")
local decode_html_entities = string_utils.decode_html_entities
local unescape_markdown = string_utils.unescape_markdown
local strip_links = string_utils.strip_links
local pad_lines = string_utils.pad_lines

function M.open_hover()
  local params = vim.lsp.util.make_position_params(0, "utf-16")

  vim.lsp.buf_request_all(0, "textDocument/hover", params, function(responses)
    local all_lines = {}
    local valid_result = false

    for client_id, response in pairs(responses) do
      if response.result and response.result.contents then
        local client = vim.lsp.get_client_by_id(client_id)
        local client_lines = vim.lsp.util.convert_input_to_markdown_lines(response.result.contents)

        -- Filtering logic
        local filtered_servers = { "jdtls", "cssls", "astro" }
        if client and vim.tbl_contains(filtered_servers, client.name) then
          client_lines = strip_links(client_lines)
          client_lines = decode_html_entities(client_lines)
        end

        vim.list_extend(all_lines, client_lines)
        valid_result = true
      end
    end

    if not valid_result or vim.tbl_isempty(all_lines) then
      return
    end

    all_lines = pad_lines(all_lines)
    all_lines = unescape_markdown(all_lines)

    -- Native window creation replacing hover.nvim
    vim.lsp.util.open_floating_preview(all_lines, "markdown", {
      border = "single",
      max_width = 85,
      max_height = 15,
      focusable = true,
      focus_id = "textDocument/hover",
    })

    -- Highlights for the native floating window
    vim.api.nvim_set_hl(0, "NormalFloat", { link = "Normal" })
    vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#4F4F4F" })
  end)
end

-- Double-tap logic for native hover
local HOVER_DOUBLE_TAP_MS = 300
local last_hover_time = 0
function M.hover_with_enter()
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
    M.open_hover()
    last_hover_time = now
  end
end

return M
