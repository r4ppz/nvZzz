local M = {}

local function add_files_to_chat(files)
  local chat = require("CopilotChat")
  if #files == 0 then
    vim.notify("No valid files to add", vim.log.levels.WARN)
    return
  end

  local cwd = vim.fn.getcwd()
  local lines = {}
  for _, file in ipairs(files) do
    local path = vim.startswith(file, cwd) and vim.fn.fnamemodify(file, ":.") or file
    table.insert(lines, "#file:" .. path)
  end

  chat.open()
  vim.schedule(function()
    vim.api.nvim_put(lines, "l", true, true)
    vim.cmd("normal! G")
  end)
end

local function collect_files_from_directory(dir)
  local all = vim.fn.globpath(dir, "**/*", false, true)
  local files = {}
  for _, item in ipairs(all) do
    if vim.fn.isdirectory(item) == 0 and vim.fn.filereadable(item) == 1 then
      table.insert(files, item)
    end
  end
  return files
end

local function node_to_files(node)
  if node.absolute_path and vim.fn.isdirectory(node.absolute_path) == 1 then
    return collect_files_from_directory(node.absolute_path)
  else
    return { node.absolute_path }
  end
end

function M.add_to_copilot()
  local bufnr = vim.api.nvim_get_current_buf()
  local ft = vim.bo[bufnr].filetype
  local files = {}

  if ft == "NvimTree" then
    local api = require("nvim-tree.api")
    local marked = api.marks.list()

    if #marked > 0 then
      for _, node in ipairs(marked) do
        vim.list_extend(files, node_to_files(node))
      end
      api.marks.clear()
    else
      local node = api.tree.get_node_under_cursor()
      if node then
        vim.list_extend(files, node_to_files(node))
      end
    end
    api.tree.close()
  else
    local file = vim.api.nvim_buf_get_name(bufnr)
    if file ~= "" and vim.fn.filereadable(file) == 1 then
      files = { file }
    else
      vim.notify("Current buffer is not a valid file", vim.log.levels.WARN)
      return
    end
  end

  add_files_to_chat(files)
end

return M
