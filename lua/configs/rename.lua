-- Code copied from Neovim core (LSP hover) I just
-- duplicated it here to add my custom floating window :p

local api = vim.api
local lsp = vim.lsp
local validate = vim.validate
local util = require("vim.lsp.util")

local M = {}

-- Custom floating window for rename
local function open_floating_input(opts, on_confirm)
  local buf = api.nvim_create_buf(false, true)
  local prompt = opts.prompt or "Rename: "
  local default_text = opts.default or ""
  local width = math.max(#prompt + #default_text + 10, 20)

  local win_opts = {
    relative = "cursor",
    row = 1,
    col = 0,
    width = width,
    height = 1,
    style = "minimal",
    border = "single",
    title = " " .. prompt,
    title_pos = "left",
  }

  local win = api.nvim_open_win(buf, true, win_opts)

  vim.b[buf].completion = false
  vim.wo[win].winhighlight = "FloatTitle:Normal"

  api.nvim_buf_set_lines(buf, 0, -1, false, { default_text })

  local function close_win()
    if api.nvim_win_is_valid(win) then
      api.nvim_win_close(win, true)
    end
    vim.cmd("stopinsert")
  end

  vim.keymap.set({ "i", "n" }, "<CR>", function()
    local lines = api.nvim_buf_get_lines(buf, 0, -1, false)
    close_win()
    on_confirm(lines[1] and lines[1] ~= "" and lines[1] or nil)
  end, { buffer = buf, silent = true })

  vim.keymap.set("n", "q", function()
    close_win()
    on_confirm(nil)
  end, { buffer = buf, silent = true })
end

local rename_ns = api.nvim_create_namespace("nvim.lsp.rename_range")

--- Renames all references to the symbol under the cursor.
---
---@param new_name string|nil If not provided, the user will be prompted for a new
---                     name using |vim.ui.input()|.
---@param opts? vim.lsp.buf.rename.Opts Additional options:
function M.rename(new_name, opts)
  validate("new_name", new_name, "string", true)
  validate("opts", opts, "table", true)

  opts = opts or {}
  local bufnr = vim._resolve_bufnr(opts.bufnr)
  local clients = lsp.get_clients({
    bufnr = bufnr,
    name = opts.name,
    -- Clients must at least support rename, prepareRename is optional
    method = "textDocument/rename",
  })
  if opts.filter then
    clients = vim.tbl_filter(opts.filter, clients)
  end

  if #clients == 0 then
    vim.notify("[LSP] Rename, no matching language servers with rename capability.")
  end

  local win = api.nvim_get_current_win()

  -- Compute early to account for cursor movements after going async
  local cword = vim.fn.expand("<cword>")

  --- @param range lsp.Range
  --- @param position_encoding 'utf-8'|'utf-16'|'utf-32'
  local function get_text_at_range(range, position_encoding)
    return api.nvim_buf_get_text(
      bufnr,
      range.start.line,
      util._get_line_byte_from_position(bufnr, range.start, position_encoding),
      range["end"].line,
      util._get_line_byte_from_position(bufnr, range["end"], position_encoding),
      {}
    )[1]
  end

  --- @param idx? integer
  --- @param client? vim.lsp.Client
  local function try_use_client(idx, client)
    if not idx or not client then
      return
    end

    --- @param name string
    local function rename(name)
      local params = util.make_position_params(win, client.offset_encoding) --[[@as lsp.RenameParams]]
      params.newName = name
      local handler = client.handlers["textDocument/rename"] or lsp.handlers["textDocument/rename"]
      client:request("textDocument/rename", params, function(...)
        handler(...)
        try_use_client(next(clients, idx))
      end, bufnr)
    end

    if client:supports_method("textDocument/prepareRename") then
      local params = util.make_position_params(win, client.offset_encoding)
      ---@param result? lsp.Range|{ range: lsp.Range, placeholder: string }
      client:request("textDocument/prepareRename", params, function(err, result)
        if err or result == nil then
          if next(clients, idx) then
            try_use_client(next(clients, idx))
          else
            local msg = err and ("Error on prepareRename: " .. (err.message or ""))
              or "Nothing to rename"
            vim.notify(msg, vim.log.levels.INFO)
          end
          return
        end

        if new_name then
          rename(new_name)
          return
        end

        local range ---@type lsp.Range?
        if result.start then
          ---@cast result lsp.Range
          range = result
        elseif result.range then
          ---@cast result { range: lsp.Range, placeholder: string }
          range = result.range
        end
        if range then
          local start = range.start
          local end_ = range["end"]
          local start_idx = util._get_line_byte_from_position(bufnr, start, client.offset_encoding)
          local end_idx = util._get_line_byte_from_position(bufnr, end_, client.offset_encoding)

          vim.hl.range(
            bufnr,
            rename_ns,
            "LspReferenceTarget",
            { start.line, start_idx },
            { end_.line, end_idx },
            { priority = vim.hl.priorities.user }
          )
        end

        local prompt_opts = {
          prompt = "New Name: ",
        }
        if result.placeholder then
          prompt_opts.default = result.placeholder
        elseif result.start then
          prompt_opts.default = get_text_at_range(result, client.offset_encoding)
        elseif result.range then
          prompt_opts.default = get_text_at_range(result.range, client.offset_encoding)
        else
          prompt_opts.default = cword
        end

        -- !Use my custom window instead of vim.ui.input
        open_floating_input(prompt_opts, function(input)
          if input and #input ~= 0 then
            rename(input)
          end
          api.nvim_buf_clear_namespace(bufnr, rename_ns, 0, -1)
        end)
      end, bufnr)
    end
  end

  try_use_client(next(clients))
end

return M
