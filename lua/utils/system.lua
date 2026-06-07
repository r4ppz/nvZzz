local M = {}

function M.mason_root()
  return vim.fn.stdpath("data") .. "/mason"
end

function M.mason_package(name)
  return M.mason_root() .. "/packages/" .. name
end

function M.is_process_running(name)
  vim.fn.system({ "pgrep", "-x", name })
  return vim.v.shell_error == 0
end

function M.is_file_exists(file, dir)
  local path = dir .. "/" .. file
  return vim.fn.filereadable(path) == 1
end

return M
