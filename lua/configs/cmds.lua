local cmd = vim.api.nvim_create_user_command

cmd("ToggleBool", function()
  local word = vim.fn.expand("<cword>")
  local replacements = {
    ["true"] = "false",
    ["false"] = "true",
    ["on"] = "off",
    ["off"] = "on",
    ["1"] = "0",
    ["0"] = "1",
  }

  local replacement = replacements[word]
  if replacement then
    vim.cmd("normal! ciw" .. replacement)
  end
end, {})

-- Markdown format shortcuts
cmd("RemoveCite", [[%s/\[cite:.\{-}\]//g]], {})
cmd("RemoveBold", [[%s/\*\*\(.\{-}\)\*\*/\1/g]], {})

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
