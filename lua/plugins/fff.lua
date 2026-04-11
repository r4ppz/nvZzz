return {
  "dmtrKovalenko/fff.nvim",
  build = function()
    require("fff.download").download_or_build_binary()
  end,
  lazy = false,
  opts = {
    prompt = "  ",
    title = "Fast As Fuck",

    layout = {
      height = 0.8,
      width = 0.8,
      prompt_position = "top",
      preview_position = "right",
      preview_size = 0.5,
      flex = {
        size = 130,
        wrap = "bottom",
      },
      show_scrollbar = false,
      path_shorten_strategy = "middle_number",
    },
    preview = {
      line_numbers = true,
    },

    keymaps = {
      preview_scroll_up = "<C-Up>",
      preview_scroll_down = "<C-Down>",
    },

    git = {
      status_text_color = false,
    },
  },
  keys = {
    {
      "<M-f>",
      function()
        require("fff").find_files()
      end,
      desc = "Find files (fff)",
    },
    {
      "<leader>fg",
      function()
        require("fff").live_grep({
          grep = {
            modes = { "fuzzy", "plain" },
          },
        })
      end,
      desc = "Live fuzzy grep (fff)",
    },
  },
}
