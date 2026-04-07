local M = {}

function M.dedent(str)
  str = str:gsub("^%s*\n", ""):gsub("\n%s*$", "")
  local min_indent = nil
  for indent in str:gmatch("\n([ \t]*)%S") do
    if min_indent == nil or #indent < #min_indent then
      min_indent = indent
    end
  end
  if not min_indent or #min_indent == 0 then
    return str
  end
  return str:gsub("\n" .. min_indent, "\n")
end

function M.decode_html_entities(lines)
  local out = {}
  for _, line in ipairs(lines) do
    local cleaned = line:gsub("&lt;", "<"):gsub("&gt;", ">"):gsub("&amp;", "&"):gsub("&quot;", '"')
    table.insert(out, cleaned)
  end
  return out
end

function M.unescape_markdown(lines)
  local out = {}
  for _, line in ipairs(lines) do
    local cleaned = line:gsub("\\([%-%._%*%[%]%(%)%{%}])", "%1")
    table.insert(out, cleaned)
  end
  return out
end

function M.strip_links(lines)
  local out = {}
  for _, line in ipairs(lines) do
    local cleaned = line:gsub("%[(.-)%]%(jdt://.-%)", "`%1`")
    cleaned = cleaned:gsub("%[(.-)%]%b()", "`%1`")
    table.insert(out, cleaned)
  end
  return out
end

function M.pad_lines(lines)
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

return M
