return {
  "MagicDuck/grug-far.nvim",
  cmd = "GrugFar",
  opts = {
    startInInsertMode = false,
    showCompactInputs = false,
    showInputsTopPadding = false,
    showInputsBottomPadding = false,
    showEngineInfo = false,
    helpLine = {
      enabled = false,
    },
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
      "<leader>R",
      function()
        require("utils.window").toggle_panel(function()
          local grug_far = require("grug-far")
          if grug_far.has_instance("grug-far-main") then
            grug_far.get_instance("grug-far-main"):close()
          else
            grug_far.open({
              transient = true,
              instanceName = "grug-far-main",
            })
          end
        end, "grug-far")
      end,
      mode = { "v", "n" },
      desc = "Toggle Grug Far",
    },
    {
      "<leader>rr",
      function()
        require("utils.window").toggle_panel(function()
          local grug_far = require("grug-far")
          if grug_far.has_instance("grug-far-file") then
            grug_far.get_instance("grug-far-file"):close()
          else
            grug_far.open({
              transient = true,
              instanceName = "grug-far-file",
              prefills = { paths = vim.fn.expand("%") },
            })
          end
        end, "grug-far")
      end,
      mode = { "n", "v" },
      desc = "Grug Far: Search on current file",
    },
    {
      "<leader>rw",
      function()
        require("utils.window").toggle_panel(function()
          local grug_far = require("grug-far")
          if grug_far.has_instance("grug-far-replace") then
            grug_far.get_instance("grug-far-replace"):close()
          else
            local inst = grug_far.open({
              transient = true,
              instanceName = "grug-far-replace",
              prefills = { search = vim.fn.expand("<cword>") },
            })
            inst:when_ready(function()
              inst:goto_input("replacement")
            end)
          end
        end, "grug-far")
      end,
      mode = { "n", "v" },
      desc = "Grug Far: replace word",
    },
  },
}
