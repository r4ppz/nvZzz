local custom_prompts = require("configs.prompts")
local win_util = require("utils.window")

return {
  "CopilotC-Nvim/CopilotChat.nvim",
  branch = "main",
  build = "make tiktoken",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "zbirenbaum/copilot.lua",
  },

  opts = function()
    return {
      system_prompt = custom_prompts.system_prompt,
      prompts = custom_prompts.prompts,

      resources = "selection",
      selection = "visual",

      temperature = 0.1,
      model = "gpt-4.1",
      -- model = "grok-code-fast-1",
      -- model = "gemini-3-flash-preview",
      -- model = "gpt-5-mini",
      -- model = "gpt-4o",
      -- model = "oswe-vscode-prime",

      window = {
        layout = "vertical",
        width = 0.5,
      },

      headers = {
        user = " r4ppz",
        assistant = "󱚝  Jarvis",
        tool = " Tool",
      },
      separator = "─",
      -- separator = "-",
      highlight_headers = true,

      auto_fold = true,
      show_folds = true,
      auto_insert_mode = false,
      auto_follow_cursor = false,
      insert_at_end = false,
      show_help = false,
      clear_chat_on_new_prompt = false,
      remember_as_sticky = false,

      instruction_files = {
        -- I am not goint to vibe code using this plugin lol
      },

      trusted_tools = { "file", "glob", "grep" },
    }
  end,

  keys = {
    {
      "<leader>ci",
      function()
        win_util.close_panels()
        vim.cmd("CopilotChatIdiomatic")
      end,
      mode = { "n", "v" },
      desc = "Check if code is idiomatic",
    },

    {
      "<leader>ce",
      function()
        win_util.close_panels()
        vim.cmd("CopilotChatExplain")
      end,
      mode = { "n", "v" },
      desc = "Explain code",
    },

    {
      "<leader>cs",
      function()
        win_util.close_panels()
        vim.cmd("CopilotChatSuggest")
      end,
      mode = { "n", "v" },
      desc = "Suggest alternatives",
    },

    {
      "<leader>cm",
      "<CMD>CopilotChatModels<CR>",
      mode = { "n", "v" },
      desc = "View/select available models",
    },

    {
      "<M-c>",
      function()
        win_util.toggle_panel(function()
          require("CopilotChat").toggle()
        end, "copilot-chat")
      end,
      mode = { "n", "v" },
      desc = "Toggle CopilotChat",
    },

    {
      "<leader>cp",
      function()
        win_util.close_panels()
        local chat = require("CopilotChat")
        chat.open()
        chat.select_prompt()
      end,
      mode = { "n", "v" },
      desc = "View/select prompt templates",
    },

    -- Open chat with current buffer
    {
      "<leader>cb",
      function()
        win_util.close_panels()
        local chat = require("CopilotChat")
        chat.open()
        chat.chat:add_message({ role = "user", content = "#buffer:active\n" })
      end,
      mode = { "n", "v" },
      desc = "Open chat with current buffer",
    },

    {
      "<leader>cB",
      function()
        win_util.close_panels()
        local chat = require("CopilotChat")
        chat.open()
        chat.chat:add_message({ role = "user", content = "#buffer:listed\n" })
      end,
      mode = { "n", "v" },
      desc = "Open chat with all buffers",
    },

    {
      "<leader>cf",
      function()
        win_util.close_panels()
        local snacks = require("snacks")
        snacks.picker.files({
          confirm = function(picker, item)
            local items = picker:selected()
            if #items == 0 then
              items = { item }
            end

            picker:close()

            local lines = {}
            for _, sel in ipairs(items) do
              local path = vim.fn.fnamemodify(sel.file, ":.")
              table.insert(lines, "#file:" .. path)
            end

            local chat = require("CopilotChat")
            chat.open()

            vim.schedule(function()
              vim.api.nvim_put(lines, "l", true, true)
              vim.cmd("normal! G")
            end)
          end,
        })
      end,
      desc = "Add files to CopilotChat",
      mode = { "n", "v" },
    },

    {
      "<C-S-M-Up>",
      function()
        win_util.close_panels()
        local params = vim.lsp.util.make_position_params(nil, "utf-16")
        local responses = vim.lsp.buf_request_sync(0, "textDocument/hover", params, 500)

        if not responses or vim.tbl_isempty(responses) then
          vim.notify("No hover information available", vim.log.levels.WARN)
          return
        end

        local parts = {}
        for _, resp in pairs(responses) do
          if resp and resp.result and resp.result.contents then
            local md = vim.lsp.util.convert_input_to_markdown_lines(resp.result.contents) or {}
            for _, line in ipairs(md) do
              if line and line ~= "" then
                parts[#parts + 1] = line
              end
            end
          end
        end

        if #parts == 0 then
          vim.notify("No hover text found", vim.log.levels.WARN)
          return
        end

        local hover_text = table.concat(parts, "\n")

        local chat = require("CopilotChat")
        chat.open()
        chat.ask(
          custom_prompts.prompts.BetterDocs.prompt .. "\n\n" .. hover_text,
          { clear_chat_on_new_prompt = true }
        )
      end,
      desc = "Explain hover with Copilot",
      mode = { "n", "v" },
    },
  },
}
