return {
  "stevearc/conform.nvim",
  event = "BufReadPre",
  opts = {
    formatters_by_ft = {
      javascript = { "prettierd" },
      javascriptreact = { "prettierd" },
      typescript = { "prettierd" },
      typescriptreact = { "prettierd" },

      css = { "prettierd" },
      html = { "prettierd" },
      json = { "prettierd" },
      markdown = { "prettierd" },
      yaml = { "prettierd" },
      qml = { "qmlformat" },

      lua = { "stylua" },
      sh = { "shfmt" },
      zsh = { "shfmt" },
      python = { "black" },
      rust = { "rustfmt" },
      xml = { "lemminx" },
      java = { "google-java-format" },
      go = { "gofmt" },

      php = { lsp_format = "fallback" },
      zig = { lsp_format = "fallback" },

      ["_"] = { "trim_whitespace" },
    },

    formatters = {
      qmlformat = {
        command = "qmlformat",
        stdin = false,
        args = { "-i", "$FILENAME" },
      },
    },

    format_after_save = {
      timeout_ms = 1000,
      async = true,
      lsp_format = "fallback",
    },
  },
}
