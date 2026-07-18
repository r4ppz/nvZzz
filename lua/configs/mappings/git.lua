local win_util = require("utils.window")
local map = require("utils.map")

-- LazyGit floating terminal
map("n", { "<M-g>", "<leader>gg" }, function()
  win_util.toggle_panel(function()
    Snacks.lazygit.open()
  end, "snacks_terminal")
end, { desc = "Lazygit (Snacks)" })

-- gitsign navigation
map("n", "]c", function()
  require("gitsigns").nav_hunk("next")
end, { desc = "Next Git Hunk (GitSign)" })
map("n", "[c", function()
  require("gitsigns").nav_hunk("prev")
end, { desc = "Previous Git Hunk (GitSign)" })

-- stage hunk/buffer
map("n", "<leader>gs", function()
  require("gitsigns").stage_hunk()
end, { desc = "Stage Hunk (GitSign)" })
map("n", "<leader>gS", function()
  require("gitsigns").stage_buffer()
end, { desc = "Stage Buffer (GitSign)" })

-- reset hunk/buffer
map("n", "<leader>gr", function()
  require("gitsigns").reset_hunk()
end, { desc = "Reset Hunk (GitSign)" })
map("n", "<leader>gR", function()
  require("gitsigns").reset_buffer()
end, { desc = "Reset Buffer (GitSign)" })

-- preview changes/blame
map("n", "<leader>gP", function()
  require("gitsigns").preview_hunk()
end, { desc = "Preview Hunk (GitSign)" })
map("n", "<leader>gp", function()
  require("gitsigns").preview_hunk_inline()
end, { desc = "Preview Hunk Inline (GitSign)" })
map("n", "<leader>gb", function()
  require("gitsigns").blame_line({ full = true })
end, { desc = "Blame Line (GitSign)" })
map("n", "<leader>gB", function()
  require("gitsigns").blame()
end, { desc = "Blame (GitSign)" })

-- DiffView
map("n", "<leader>gd", "<cmd>DiffviewOpen<cr>", {
  desc = "Open Diffview",
})
map("n", "<leader>gh", "<cmd>DiffviewFileHistory<cr>", {
  desc = "Open Diffview History (Diffview)",
})
map("n", "<leader>gf", "<cmd>DiffviewFileHistory %<cr>", {
  desc = "Open Diffview Current File History (Diffview)",
})

-- Interactive Branch Comparison using vim.ui.select
map("n", "<leader>gD", function()
  -- Fetch all branches (local and remote)
  local raw_branches = vim.fn.systemlist("git branch -a --format='%(refname:short)'")
  if vim.v.shell_error ~= 0 or #raw_branches == 0 then
    vim.notify("Not a git repository or no branches found", vim.log.levels.ERROR)
    return
  end

  -- Clean up names: remove 'remotes/' prefix and filter out HEAD artifacts
  local branches = {}
  for _, branch in ipairs(raw_branches) do
    if not string.find(branch, "HEAD") and branch ~= "" and branch ~= "origin" then
      -- Strips 'remotes/origin/main' down to 'origin/main' for cleaner UI and commands
      local clean_name = string.gsub(branch, "^remotes/", "")
      table.insert(branches, clean_name)
    end
  end

  -- Select baseline revision (Left Side)
  vim.ui.select(branches, {
    prompt = "Diffview: Select Baseline (Left Side) > ",
  }, function(left_rev)
    if not left_rev then
      return
    end -- User aborted

    -- Select target revision (Right Side)
    vim.schedule(function()
      vim.ui.select(branches, {
        prompt = string.format(
          "Diffview: Select Target (Right Side, comparing vs %s) > ",
          left_rev
        ),
      }, function(right_rev)
        if not right_rev then
          return
        end -- User aborted

        -- Execute the range comparison
        local cmd = string.format("DiffviewOpen %s..%s", left_rev, right_rev)
        vim.cmd(cmd)
      end)
    end)
  end)
end, {
  desc = "Open Diffview branch comparison (inc. remotes)",
})
