local map = function(mode, lhs, rhs, opts)
  if not lhs then
    return
  end

  opts = opts or {}

  if type(lhs) == "table" then
    for i = 1, #lhs do
      vim.keymap.set(mode, lhs[i], rhs, opts)
    end
    return
  end

  vim.keymap.set(mode, lhs, rhs, opts)
end

return map
