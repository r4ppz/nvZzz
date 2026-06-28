return {
  "nvim-tree/nvim-tree.lua",
  opts = function()
    return {
      filters = {
        dotfiles = false,
        git_ignored = false,
        custom = {},
      },

      disable_netrw = true,
      hijack_cursor = true,
      sync_root_with_cwd = true,

      update_focused_file = {
        enable = true,
        update_root = false,
      },

      view = {
        width = 40,
        side = "left",
        preserve_window_proportions = true,
      },

      actions = {
        open_file = {
          quit_on_open = false,
        },
      },

      git = {
        enable = true,
        show_on_dirs = true,
      },

      diagnostics = {
        enable = false,
        show_on_dirs = true,
        show_on_open_dirs = true,
        icons = {
          hint = "",
          info = "",
          warning = "",
          error = "",
        },
      },

      renderer = {
        group_empty = true,
        root_folder_label = false,
        highlight_git = "none",
        indent_markers = { enable = true },
        icons = {
          git_placement = "after",

          glyphs = {
            default = "󰈚",
          },
        },
      },

      on_attach = function(bufnr)
        local map = vim.keymap.set
        local api = require("nvim-tree.api")

        api.map.on_attach.default(bufnr)

        -- Context-aware file renaming via Snacks
        map("n", "r", function()
          local node = api.tree.get_node_under_cursor()
          if not node or node.name == ".." then
            return
          end

          local old_path = node.absolute_path
          local old_name = vim.fs.basename(old_path)

          vim.ui.input({ prompt = "Rename to: ", default = old_name }, function(input)
            if not input or input == "" or input == old_name then
              return
            end
            Snacks.rename.rename_file({
              from = old_path,
              to = vim.fs.joinpath(vim.fs.dirname(old_path), input),
            })
          end)
        end, { buffer = bufnr })

        map("n", "<ESC>", "<nop>", { buffer = bufnr, desc = "fucking nothing" })
        map("n", "<C-S-Up>", api.node.show_info_popup, { buffer = bufnr, desc = "Info" })
        map("n", "<C-]>", api.tree.change_root_to_node, { buffer = bufnr, desc = "cd" })
        map("n", "<C-[>", api.tree.change_root_to_parent, { buffer = bufnr, desc = "cd .." })
      end,
    }
  end,

  keys = {
    { "<M-e>", "<cmd>NvimTreeToggle<CR>", desc = "Toggle NvimTree" },
    {
      "<leader>ca",
      function()
        local win_util = require("utils.window")
        win_util.close_panels()

        if vim.bo.filetype == "copilot-chat" then
          win_util.focus_main_window()
        end

        require("utils.tree_chat").add_to_copilot()
      end,
      desc = "Add file/s to CopilotChat",
    },
  },
}
