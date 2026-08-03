local languages = {
  "luadoc",
  "printf",
  "vim",
  "vimdoc",
  "markdown",
  "latex",
  "markdown_inline",
  "query",
  "ini",
  "udev",
  "ssh_config",
  "kitty",

  "diff",
  "git_config",
  "gitcommit",
  "git_rebase",
  "gitignore",
  "gitattributes",
  "regex",
  "rasi",

  "sql",
  "lua",
  "bash",
  "zsh",
  "java",
  "rust",
  "python",
  "c",
  "zig",
  "asm",
  "cpp",
  "hyprlang",
  "go",
  "gomod",
  "gowork",
  "gosum",
  "php",
  "blade",

  "yaml",
  "toml",
  "xml",
  "json",
  "qmljs",

  "html",
  "css",
  "javascript",
  "typescript",
  "tsx",
  "astro",
  "svelte",
  "prisma",
}

return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = function()
    require("nvim-treesitter").install(languages)
  end,
  config = function()
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("TreesitterSetup", { clear = true }),
      callback = function(args)
        local buf = args.buf
        local ft = vim.bo[buf].filetype
        if ft == "" then
          return
        end

        local lang = vim.treesitter.language.get_lang(ft) or ft

        if pcall(vim.treesitter.start, buf, lang) then
          vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })
  end,
}
