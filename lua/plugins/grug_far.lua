local function toggle_grug_far(resolve_prefills, goto_input)
  return function()
    require("utils.window").toggle_panel(function()
      local gf = require("grug-far")
      local name = "grug-far-main"
      local prefills = resolve_prefills and resolve_prefills()

      local inst
      if gf.has_instance(name) then
        inst = gf.get_instance(name)
        if not inst then
          return
        end
        if inst:is_open() then
          inst:hide()
          return
        end
        inst:open()
        if prefills then
          inst:update_input_values(prefills, true)
        end
      else
        inst = gf.open({ instanceName = name, prefills = prefills or {} })
        if not inst then
          return
        end
      end

      if goto_input and inst then
        inst:when_ready(function()
          inst:goto_input(goto_input)
        end)
      end
    end, "grug-far")
  end
end

return {
  "MagicDuck/grug-far.nvim",
  dev = true,
  init = function()
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "grug-far",
      callback = function()
        vim.bo.buflisted = false
      end,
    })
  end,
  opts = {
    startInInsertMode = false,
    showCompactInputs = false,
    showInputsTopPadding = false,
    showInputsBottomPadding = false,
    showEngineInfo = false,
    helpLine = {
      enabled = false,
    },
    folding = {
      enabled = false,
    },
    windowCreationCommand = "vsplit | vertical resize " .. math.floor(vim.o.columns * 0.4),
    resultLocation = { showNumberLabel = false },
    engines = {
      ripgrep = { placeholders = { enabled = false } },
      astgrep = { placeholders = { enabled = false } },
      ["astgrep-rules"] = { placeholders = { enabled = false } },
    },
    keymaps = {
      applyNext = { n = "<localleader><down>" },
      applyPrev = { n = "<localleader><up>" },
      close = { n = "q" },
    },
  },
  keys = {
    {
      "<leader>rr",
      toggle_grug_far(),
      mode = { "v", "n" },
      desc = "Grug Far (global)",
    },
    {
      "<leader>rf",
      toggle_grug_far(function()
        return {
          search = vim.fn.expand("<cword>"),
          paths = vim.fn.expand("%"),
        }
      end, "replacement"),
      mode = { "n", "v" },
      desc = "Grug Far (current file + prefills)",
    },
    {
      "<leader>rw",
      toggle_grug_far(function()
        return { search = vim.fn.expand("<cword>") }
      end, "replacement"),
      mode = { "n", "v" },
      desc = "Grug Far (global + prefills)",
    },
    {
      "<leader>rc",
      function()
        local inst = require("grug-far").get_instance("grug-far-main")
        if inst then
          inst:close()
        end
      end,
      mode = { "n", "v" },
      desc = "Grug Far (close)",
    },
  },
}
