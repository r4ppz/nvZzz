local string = require("utils.string")

local decode_html_entities = string.decode_html_entities
local unescape_markdown = string.unescape_markdown
local strip_links = string.strip_links
local pad_lines = string.pad_lines

return {
  name = "Hover Docs",
  priority = 1000,

  enabled = function(bufnr)
    return #vim.lsp.get_clients({ bufnr = bufnr }) > 0
  end,

  execute = function(_, done)
    local function process_response(client_id, response, all_lines)
      if not (response.result and response.result.contents) then
        return false
      end

      local client = vim.lsp.get_client_by_id(client_id)
      local client_lines = vim.lsp.util.convert_input_to_markdown_lines(response.result.contents)

      -- Apply filters for specific servers
      local filtered_servers = { "jdtls", "cssls", "astro" }
      if client and vim.tbl_contains(filtered_servers, client.name) then
        client_lines = strip_links(client_lines)
        client_lines = decode_html_entities(client_lines)
      end

      vim.list_extend(all_lines, client_lines)
      return true
    end

    local function handle_responses(responses)
      local all_lines = {}
      local valid_result = false

      for client_id, response in pairs(responses) do
        if process_response(client_id, response, all_lines) then
          valid_result = true
        end
      end

      if not valid_result or vim.tbl_isempty(all_lines) then
        done(false)
        return
      end

      all_lines = pad_lines(all_lines)
      all_lines = unescape_markdown(all_lines)

      done({ lines = all_lines, filetype = "markdown" })
    end

    local params = vim.lsp.util.make_position_params(0, "utf-16")
    vim.lsp.buf_request_all(0, "textDocument/hover", params, handle_responses)
  end,
}
