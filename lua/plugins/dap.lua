return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",
    "theHamsta/nvim-dap-virtual-text",
    "jbyuki/one-small-step-for-vimkind",
    {
      "jay-babu/mason-nvim-dap.nvim",
      opts = {
        ensure_installed = require("configs.debuggers.debuggers").dap_list,
        automatic_installation = true,
      },
    },
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    dapui.setup()

    require("nvim-dap-virtual-text").setup({
      enabled = true,
      highlight_changed_variables = true,
      highlight_new_as_changed = true,
      show_stop_reason = true,
      virt_text_pos = "eol",
    })

    dap.listeners.before.attach.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.launch.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated.dapui_config = function()
      dapui.close()
    end
    dap.listeners.before.event_exited.dapui_config = function()
      dapui.close()
    end

    vim.fn.sign_define("DapBreakpoint", {
      text = "",
      texthl = "DapBreakpoint",
      linehl = "",
      numhl = "",
    })
    vim.fn.sign_define("DapBreakpointCondition", {
      text = "",
      texthl = "DapBreakpointCondition",
      linehl = "",
      numhl = "",
    })
    vim.fn.sign_define("DapBreakpointRejected", {
      text = "",
      texthl = "DapBreakpointRejected",
      linehl = "",
      numhl = "",
    })
    vim.fn.sign_define("DapLogPoint", {
      text = "",
      texthl = "DapLogPoint",
      linehl = "",
      numhl = "",
    })
    vim.fn.sign_define("DapStopped", {
      text = "➔",
      texthl = "DapStopped",
      linehl = "DapStoppedLine",
      numhl = "",
    })

    vim.api.nvim_set_hl(0, "DapBreakpoint", { fg = "#e51400", bg = "NONE" })
    vim.api.nvim_set_hl(0, "DapBreakpointCondition", { fg = "#f5a623", bg = "NONE" })
    vim.api.nvim_set_hl(0, "DapBreakpointRejected", { fg = "#888888", bg = "NONE" })
    vim.api.nvim_set_hl(0, "DapLogPoint", { fg = "#61afef", bg = "NONE" })
    vim.api.nvim_set_hl(0, "DapStopped", { fg = "#98c379", bg = "NONE" })
    vim.api.nvim_set_hl(0, "DapStoppedLine", { bg = "#2a2d3e" })

    require("configs.debuggers.debuggers").setup()
  end,

  keys = {
    -- Execution
    {
      "<leader>dc",
      function()
        require("dap").continue()
      end,
      desc = "Debug: Start/Continue",
    },
    {
      "<leader>di",
      function()
        require("dap").step_into()
      end,
      desc = "Debug: Step Into",
    },
    {
      "<leader>do",
      function()
        require("dap").step_over()
      end,
      desc = "Debug: Step Over",
    },
    {
      "<leader>du",
      function()
        require("dap").step_out()
      end,
      desc = "Debug: Step Out",
    },
    {
      "<leader>dR",
      function()
        require("dap").run_to_cursor()
      end,
      desc = "Debug: Run to Cursor",
    },
    {
      "<leader>ds",
      function()
        require("osv").launch({ port = 8086 })
      end,
      desc = "Debug: Launch OSV Server",
    },

    -- Breakpoints
    {
      "<leader>db",
      function()
        require("dap").toggle_breakpoint()
      end,
      desc = "Debug: Toggle Breakpoint",
    },
    {
      "<leader>dB",
      function()
        require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
      end,
      desc = "Debug: Conditional Breakpoint",
    },
    {
      "<leader>dL",
      function()
        require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
      end,
      desc = "Debug: Log Point",
    },

    -- Session
    {
      "<leader>dq",
      function()
        require("dap").terminate()
      end,
      desc = "Debug: Terminate",
    },
    {
      "<leader>dr",
      function()
        require("dap").repl.toggle()
      end,
      desc = "Debug: Toggle REPL",
    },
    {
      "<leader>dU",
      function()
        require("dapui").toggle()
      end,
      desc = "Debug: Toggle UI",
    },

    -- Eval (works in normal and visual mode)
    {
      "<leader>dh",
      function()
        require("dapui").eval()
      end,
      mode = { "n", "v" },
      desc = "Debug: Eval Expression",
    },
  },
}
