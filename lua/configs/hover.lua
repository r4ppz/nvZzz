-- Code copied from Neovim core (LSP hover). I don't own this.
-- I just duplicated it here to insert some custom post-parsing logic before rendering.

local api = vim.api
local lsp = vim.lsp
local validate = vim.validate
local util = require("vim.lsp.util")

local M = {}

-- Converts all variations of Markdown links into inline code blocks containing their display text.
local function strip_markdown_links(text)
  if not text then
    return text
  end
  local s = text

  -- Standard inline links and images: [text](url) -> `text`
  s = s:gsub("%!?%[([^%]]-)%]%([^%)]-%)", "`%1`")

  -- Reference links: [text][id] -> `text`
  s = s:gsub("%[([^%]]-)%]%s*%[[^%]]-%]", "`%1`")

  -- URI Autolinks: <https://example.com> -> `https://example.com`
  s = s:gsub("<([%a%d%+%.-]+://[^>]-)>", "`%1`")

  -- Email Autolinks: <user@example.com> -> `user@example.com`
  s = s:gsub("<([^>]+@[^>]-)>", "`%1`")

  return s
end

-- Removes literal backslashes used to escape characters in the raw Markdown source.
local function remove_escaped_backslashes(text)
  if not text then
    return text
  end
  return text:gsub("\\", "")
end

--- @param params? table
--- @return fun(client: vim.lsp.Client): lsp.TextDocumentPositionParams
local function client_positional_params(params)
  local win = api.nvim_get_current_win()
  return function(client)
    local ret = util.make_position_params(win, client.offset_encoding)
    if params then
      ret = vim.tbl_extend("force", ret, params)
    end
    return ret
  end
end

local hover_ns = api.nvim_create_namespace("nvim.lsp.hover_range")

--- Returns false if the LSP response is stale and should be discarded.
--- @param ctx lsp.HandlerContext
--- @return boolean
local function ctx_is_valid(ctx)
  local bufnr = ctx.bufnr
  if
    not bufnr
    or not api.nvim_buf_is_valid(bufnr)
    or api.nvim_get_current_buf() ~= bufnr
    or vim.lsp.util.buf_versions[bufnr] ~= ctx.version
  then
    return false
  end
  local p = ctx.params and ctx.params.position
  if not p then
    return true
  end

  local cur = api.nvim_win_get_cursor(0)
  local c = lsp.get_client_by_id(ctx.client_id)
  local enc = c and c.offset_encoding

  return cur[1] - 1 == p.line and enc and cur[2] == util._get_line_byte_from_position(bufnr, p, enc)
    or false
end

--- @class vim.lsp.buf.hover.Opts : vim.lsp.util.open_floating_preview.Opts
---@diagnostic disable-next-line: duplicate-doc-field
--- @field silent? boolean

--- Displays hover information about the symbol under the cursor in a floating
--- window. The window will be dismissed on cursor move.
--- Calling the function twice will jump into the floating window
--- (thus by default, "KK" will open the hover window and focus it).
--- In the floating window, all commands and mappings are available as usual,
--- except that "q" dismisses the window.
--- You can scroll the contents the same as you would any other buffer.
---
--- Note: to disable hover highlights, add the following to your config:
---
--- ```lua
--- vim.api.nvim_create_autocmd('ColorScheme', {
---   callback = function()
---     vim.api.nvim_set_hl(0, 'LspReferenceTarget', {})
---   end,
--- })
--- ```
--- @param config? vim.lsp.buf.hover.Opts
function M.hover(config)
  validate("config", config, "table", true)

  config = config or {}
  config.focus_id = "textDocument/hover"

  lsp.buf_request_all(0, "textDocument/hover", client_positional_params(), function(results, ctx)
    local bufnr = ctx.bufnr
    if not bufnr or not ctx_is_valid(ctx) then
      return -- Ignore result if context changed. Can happen for slow LS.
    end

    -- Filter errors from results
    local results1 = {} --- @type table<integer,lsp.Hover>
    local nresults = 0
    local empty_response = false

    for client_id, resp in pairs(results) do
      local err, result = resp.err, resp.result
      if err then
        lsp.log.error(err.code, err.message)
      elseif result and result.contents then
        -- Make sure the response is not empty
        -- Five response shapes:
        -- - MarkupContent: { kind="markdown", value="doc" }
        -- - MarkedString-string: "doc"
        -- - MarkedString-pair: { language="c", value="doc" }
        -- - MarkedString[]-string: { "doc1", ... }
        -- - MarkedString[]-pair: { { language="c", value="doc1" }, ... }
        local valid = false
        if type(result.contents) == "table" then
          local value_len = #(
            vim.tbl_get(result.contents, "value") -- MarkupContent or MarkedString-pair
            or vim.tbl_get(result.contents, 1, "value") -- MarkedString[]-pair
            or result.contents[1] -- MarkedString[]-string
            or ""
          )
          valid = value_len > 0
        elseif type(result.contents) == "string" then
          valid = #result.contents > 0
        end

        if valid then
          results1[client_id] = result
          nresults = nresults + 1
        else
          empty_response = true
        end
      end
    end

    if nresults == 0 then
      if config.silent ~= true then
        if empty_response then
          vim.notify("Empty hover response", vim.log.levels.INFO)
        else
          vim.notify("No information available", vim.log.levels.INFO)
        end
      end
      return
    end

    local contents = {} --- @type string[]
    local MarkupKind = lsp.protocol.MarkupKind
    local format = MarkupKind.Markdown

    for client_id, result in pairs(results1) do
      local client = assert(lsp.get_client_by_id(client_id))
      if nresults > 1 then
        -- Show client name if there are multiple clients
        contents[#contents + 1] = string.format("# %s", client.name)
      end

      if type(result.contents) == "table" and result.contents.kind == MarkupKind.PlainText then
        if nresults == 1 then
          -- Only one client: use PlainText format
          format = MarkupKind.PlainText
          contents = vim.split(result.contents.value or "", "\n", { trimempty = true })
        else
          -- Multiple clients: surround plaintext with ``` to get correct formatting
          contents[#contents + 1] = "```"
          vim.list_extend(
            contents,
            vim.split(result.contents.value or "", "\n", { trimempty = true })
          )
          contents[#contents + 1] = "```"
        end
      else
        vim.list_extend(contents, util.convert_input_to_markdown_lines(result.contents))
      end
      local range = result.range
      if range then
        local start = range.start
        local end_ = range["end"]
        local start_idx = util._get_line_byte_from_position(bufnr, start, client.offset_encoding)
        local end_idx = util._get_line_byte_from_position(bufnr, end_, client.offset_encoding)

        vim.hl.range(
          bufnr,
          hover_ns,
          "LspReferenceTarget",
          { start.line, start_idx },
          { end_.line, end_idx },
          { priority = vim.hl.priorities.user }
        )
      end
      contents[#contents + 1] = "---"
    end

    -- Remove last linebreak ('---') if contents is not empty
    if #contents > 0 then
      contents[#contents] = nil
    end

    for i, line in ipairs(contents) do
      contents[i] = remove_escaped_backslashes(strip_markdown_links(line))
    end

    local _, winid = lsp.util.open_floating_preview(contents, format, config)

    api.nvim_create_autocmd("WinClosed", {
      pattern = tostring(winid),
      once = true,
      callback = function()
        api.nvim_buf_clear_namespace(bufnr, hover_ns, 0, -1)
        return true
      end,
    })
  end)
end

return M
