return {
  "lewis6991/hover.nvim",
  event = "LspAttach",
  config = function()
    require("hover").setup({
      providers = {
        "configs.providers.hover",
      },
      title = false,
      preview_opts = {
        border = "single",
        wrap = true,
        max_width = 85,
        max_height = 15,
      },
    })

    vim.api.nvim_set_hl(0, "HoverWindow", { link = "NormalFloat" })
    -- vim.api.nvim_set_hl(0, "HoverBorder", { fg = "#82A497" })
    vim.api.nvim_set_hl(0, "HoverBorder", { fg = "#4F4F4F" })

    local hover = require("hover")
    local map = vim.keymap.set

    -- double-tap detection
    local last = 0
    local function hover_handler()
      local now = vim.loop.now()
      if now - last < 300 then
        hover.enter()
      else
        hover.open()
      end
      last = now
    end

    map("n", "K", hover_handler, {
      desc = "Hover (double tap enters docs)",
    })
    map("n", "<S-C-Up>", hover_handler, {
      desc = "Hover (double tap enters docs)",
    })
  end,
}
