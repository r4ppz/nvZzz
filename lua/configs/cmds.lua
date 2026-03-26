local cmd = vim.api.nvim_create_user_command

cmd("BufInfo", function()
  local ft = vim.bo.filetype
  local bt = vim.bo.buftype

  if ft == "" then
    ft = "[none]"
  end
  if bt == "" then
    bt = "[normal]"
  end

  print("filetype: " .. ft .. " | buftype: " .. bt)
end, {})

cmd("OpenConfig", function()
  vim.cmd("tabnew")
  local conf = vim.fn.stdpath("config")
  vim.cmd("tcd " .. conf .. " | e init.lua")
end, {})
