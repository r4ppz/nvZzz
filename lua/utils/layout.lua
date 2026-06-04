local M = {}

M.bottom = {
  layout = {
    box = "vertical",
    row = -1,
    width = 0,
    height = 0.5,
    border = "top",
    { win = "input", height = 1, border = "bottom" },
    {
      box = "horizontal",
      {
        win = "list",
        border = "none",
      },
      {
        win = "preview",
        title = "{preview}",
        width = 0.5,
        border = "left",
      },
    },
  },
}

M.references = {
  layout = {
    box = "vertical",
    row = -1,
    width = 0,
    height = 0.4,
    border = "top",
    {
      box = "horizontal",
      {
        win = "list",
        border = "none",
      },
      {
        win = "preview",
        title = "{preview}",
        width = 0.5,
        border = "left",
      },
    },
  },
}

M.side = {
  preview = "main",
  layout = {
    backdrop = false,
    width = 40,
    min_width = 40,
    height = 0,
    position = "right",
    border = "none",
    box = "vertical",
    { win = "list", border = "none" },
    { win = "preview", title = "{preview}", height = 0.4, border = "top" },
  },
}

return M
