local function decode_html_entities(lines)
  local out = {}
  for _, line in ipairs(lines) do
    local cleaned = line:gsub("&lt;", "<"):gsub("&gt;", ">"):gsub("&amp;", "&"):gsub("&quot;", '"')
    table.insert(out, cleaned)
  end
  return out
end

local function unescape_markdown(lines)
  local out = {}
  for _, line in ipairs(lines) do
    local cleaned = line:gsub("\\([%-%._%*%[%]%(%)%{%}])", "%1")
    table.insert(out, cleaned)
  end
  return out
end

local function strip_links(lines)
  local out = {}
  for _, line in ipairs(lines) do
    local cleaned = line:gsub("%[(.-)%]%(jdt://.-%)", "`%1`")
    cleaned = cleaned:gsub("%[(.-)%]%b()", "`%1`")
    table.insert(out, cleaned)
  end
  return out
end

local function pad_lines(lines)
  if #lines == 0 then
    return {}
  end
  local out = { "" }
  for _, l in ipairs(lines) do
    table.insert(out, " " .. l .. " ")
  end
  table.insert(out, "")
  return out
end

return {
  name = "Hover Docs",
  priority = 1000,
  enabled = function(bufnr)
    return #vim.lsp.get_clients({ bufnr = bufnr }) > 0
  end,

  execute = function(_, done)
    local params = vim.lsp.util.make_position_params(0, "utf-16")

    vim.lsp.buf_request_all(0, "textDocument/hover", params, function(responses)
      local all_lines = {}
      local valid_result = false

      for client_id, response in pairs(responses) do
        if response.result and response.result.contents then
          valid_result = true

          local client = vim.lsp.get_client_by_id(client_id)
          local client_lines = vim.lsp.util.convert_input_to_markdown_lines(response.result.contents)

          -- Only apply these filters to these servers
          local servers = { "jdtls", "cssls" }
          if client and vim.tbl_contains(servers, client.name) then
            client_lines = strip_links(client_lines)
            client_lines = decode_html_entities(client_lines)
          end

          for _, line in ipairs(client_lines) do
            table.insert(all_lines, line)
          end
        end
      end

      if not valid_result then
        done(false)
        return
      end

      all_lines = pad_lines(all_lines)
      all_lines = unescape_markdown(all_lines)

      if vim.tbl_isempty(all_lines) then
        done(false)
        return
      end

      done({ lines = all_lines, filetype = "markdown" })
    end)
  end,
}
