return {
  "willothy/flatten.nvim",
  lazy = false,
  priority = 1001,
  opts = function()
    local flatten = require("flatten")

    local saved_terminal = nil -- bufnr of the focused terminal, if any

    return {
      window = {
        open = "tab",
        diff = "tab_vsplit",
      },
      block_for = {
        gitcommit = true,
        gitrebase = true,
      },
      hooks = {
        -- Force flatten to BLOCK for diff mode (-d flag)
        should_block = function(argv)
          if vim.tbl_contains(argv, "-d") then
            return true
          end
          return flatten.hooks.should_block(argv)
        end,

        pre_open = function()
          -- Save the focused terminal so block_end can return to it
          saved_terminal = nil
          local cur_buf = vim.api.nvim_win_get_buf(vim.api.nvim_get_current_win())
          if vim.bo[cur_buf].buftype == "terminal" then
            saved_terminal = cur_buf
          end
        end,

        post_open = function(opts)
          -- Unpack fields from opts context table
          local bufnr = opts.bufnr
          local winnr = opts.winnr
          local ft = opts.filetype
          local is_diff = opts.is_diff

          if winnr and vim.api.nvim_win_is_valid(winnr) then
            vim.api.nvim_set_current_win(winnr)
          end

          -- Mark every git-blob temp buffer in the new diff tab as wipe-on-close
          if is_diff then
            for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
              local buf = vim.api.nvim_win_get_buf(win)
              local name = vim.api.nvim_buf_get_name(buf)
              -- Wipe git-blob temp files and the unnamed stdin buffer
              if name == "" or name:match("git%-blob%-") then
                vim.bo[buf].buftype = "nofile"
                vim.bo[buf].bufhidden = "wipe"
              end
            end
          end

          -- Clean up gitcommit buffers on write (:wq)
          if ft == "gitcommit" or ft == "gitrebase" then
            vim.bo[bufnr].bufhidden = "wipe"
            vim.api.nvim_create_autocmd("BufWritePost", {
              buffer = bufnr,
              once = true,
              callback = vim.schedule_wrap(function()
                if vim.api.nvim_buf_is_valid(bufnr) then
                  vim.api.nvim_buf_delete(bufnr, {})
                end
              end),
            })
          end
        end,

        block_end = function()
          -- Bring back the terminal we came from
          vim.schedule(function()
            if saved_terminal and vim.api.nvim_buf_is_valid(saved_terminal) then
              for _, win in ipairs(vim.api.nvim_list_wins()) do
                if vim.api.nvim_win_get_buf(win) == saved_terminal then
                  vim.api.nvim_set_current_win(win)
                  break
                end
              end
            end
            saved_terminal = nil
          end)
        end,
      },
    }
  end,
}
