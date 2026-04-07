return {
  "lewis6991/hover.nvim",
  event = "LspAttach",
  config = function()
    require("hover").setup({
      providers = {
        "configs.providers.hover",
        "hover.providers.dictionary",
        "hover.providers.diagnostic",
        "hover.providers.dap",
        "hover.providers.man",
      },
      title = false,
      preview_opts = {
        border = "single",
        wrap = true,
        max_width = 85,
        max_height = 15,
      },
      preview_window = false,
    })

    vim.api.nvim_set_hl(0, "HoverWindow", { link = "NormalFloat" })
    -- vim.api.nvim_set_hl(0, "HoverBorder", { fg = "#82A497" })
    vim.api.nvim_set_hl(0, "HoverBorder", { fg = "#4F4F4F" })

    local hover = require("hover")
    local map = vim.keymap.set

    -- double-tap detection
    local last = 0
    map("n", "K", function()
      local now = vim.loop.now()
      if now - last < 300 then
        hover.enter()
      else
        hover.open()
      end
      last = now
    end, { desc = "Hover (double tap enters docs)" })

    map("n", "<S-C-Up>", function()
      local now = vim.loop.now()
      if now - last < 300 then
        hover.enter()
      else
        hover.open()
      end
      last = now
    end, { desc = "Hover (double tap enters docs)" })

    map("n", "<C-S-Left>", function()
      require("hover").switch("previous")
    end, { desc = "hover.nvim (previous source)" })

    map("n", "<S-C-Right>", function()
      require("hover").switch("next")
    end, { desc = "hover.nvim (next source)" })
  end,
}
