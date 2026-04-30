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

      lua = { "stylua" },
      sh = { "shfmt" },
      zsh = { "shfmt" },
      python = { "black" },
      rust = { "rustfmt" },
      xml = { "lemminx" },
      java = { "google-java-format" },
      go = { "gofmt" },

      ["_"] = { "trim_whitespace" },
    },

    format_after_save = {
      timeout_ms = 1000,
      async = true,
      lsp_format = "fallback",
    },
  },
}
