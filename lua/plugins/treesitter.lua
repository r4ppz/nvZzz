return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  config = function()
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
      "tmux",
      "kitty",

      "diff",
      "git_config",
      "gitcommit",
      "git_rebase",
      "gitignore",
      "gitattributes",
      "regex",

      "sql",
      "lua",
      "bash",
      "java",
      "rust",
      "python",
      "c",
      "asm",
      "cpp",
      "hyprlang",
      "go",
      "gomod",
      "gowork",
      "gosum",

      "yaml",
      "toml",
      "xml",
      "json",

      "html",
      "css",
      "javascript",
      "typescript",
      "tsx",
      "astro",
      "svelte",
      "prisma",
    }

    require("nvim-treesitter").install(languages)

    -- Enable highlighting automatically for all buffers where a parser exists
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("TreesitterSetup", { clear = true }),
      callback = function(args)
        local buf = args.buf
        local lang = vim.treesitter.language.get_lang(vim.bo[buf].filetype) or vim.bo[buf].filetype
        local ok, _ = pcall(vim.treesitter.start, buf, lang)
        if ok then
          vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })
  end,
}
