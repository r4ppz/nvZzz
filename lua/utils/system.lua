local M = {}

function M.is_process_running(name)
  local handle = io.popen("pgrep -x " .. name)
  if not handle then
    return false
  end
  local result = handle:read("*a")
  handle:close()
  return result ~= ""
end

function M.is_file_exists(file, dir)
  local path = dir .. "/" .. file
  local f = io.open(path, "r")
  if f ~= nil then
    f:close()
    return true
  end
  return false
end

return M
