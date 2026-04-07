return {
  "chentoast/marks.nvim",
  event = "VeryLazy",
  config = function()
    require("marks").setup({
      default_mappings = false,
      mappings = {},
    })

    local map = vim.keymap.set

    map("n", ";;", function()
      require("marks").toggle()
    end, { desc = "Toggle next available mark" })

    map("n", "''", function()
      require("marks").next()
    end, { desc = "Cycle next mark" })
    map("n", '""', function()
      require("marks").next()
    end, { desc = "Cycle next mark" })

    map("n", ";X", function()
      require("marks").delete_buf()
    end, { desc = "Delete all marks in buffer" })

    map("n", ";D", function()
      require("marks").delete_line()
    end, { desc = "Delete all marks on line" })

    -- I disable shada btw (see options.lua)
    -- So every session is new, which is better imo.

    -- This is closer to my arrowkeys
    map("n", ";", "<nop>")
    map("n", "'", "<nop>")

    -- Five globals (A–E)
    -- Limit to 5 cause my brain cant handle that many anyway.
    -- It kinda like global bookmark or something like that.
    local marks = { "A", "B", "C", "D", "E" }
    for i, mark in ipairs(marks) do
      map("n", ";" .. i, "m" .. mark, { desc = "which_key_ignore" })
      map("n", "'" .. i, "`" .. mark, { desc = "which_key_ignore" })
    end

    -- All lowercase locals
    for c = string.byte("a"), string.byte("z") do
      local letter = string.char(c)
      map("n", ";" .. letter, "m" .. letter, { desc = "which_key_ignore" })
      map("n", "'" .. letter, "`" .. letter, { desc = "which_key_ignore" })
    end
  end,
}
