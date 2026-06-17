# My Personal Neovim Configuration

_UI powered by [NvChad](https://nvchad.com/)_

<img width="1920" height="1080" alt="Image" src="https://github.com/user-attachments/assets/b95c6e87-6a39-4e2a-832a-18a650925cb9" />

<img width="1366" height="768" alt="Image" src="https://github.com/user-attachments/assets/1aa9c559-7fc8-4af4-b76e-da39b3c55952" />

<img width="1366" height="768" alt="Image" src="https://github.com/user-attachments/assets/2ec1e452-7223-4fb0-aba8-a6723f7d8e3b" />

---

<details>
<summary>Features & more screenshots</summary>

> These are just some of the many features

AI Integration (Copilot)
<img width="1366" height="768" alt="Image" src="https://github.com/user-attachments/assets/fa0f5a90-9b39-4893-bb23-6716fc0d9962" />

AI Predefined [Prompts](lua/configs/prompts.lua)
<img width="1366" height="768" alt="Image" src="https://github.com/user-attachments/assets/c13ea85f-add2-47b9-a646-5f1571d025e1" />

Git Client (LazyGit)
<img width="1366" height="768" alt="Image" src="https://github.com/user-attachments/assets/53ae2f2e-6076-4528-b421-feb7cc5baaf0" />

Git DiffView
<img width="1366" height="768" alt="Image" src="https://github.com/user-attachments/assets/1d2f947e-8a4f-4876-b1a5-5ec5a7188a34" />

Git Inline Diff
<img width="1366" height="768" alt="Image" src="https://github.com/user-attachments/assets/1a6805b3-d489-4977-a65a-b1adf428be0f" />

Debugger (DAP)
<img width="1920" height="1080" alt="Image" src="https://github.com/user-attachments/assets/5217107a-b253-41ca-ba65-9903c223bc9b" />

Docker Integration (LazyDocker)
<img width="1366" height="768" alt="Image" src="https://github.com/user-attachments/assets/e7caa1b1-d2b2-4391-bfb3-5301349f1d57" />

LSP References
<img width="1366" height="768" alt="Image" src="https://github.com/user-attachments/assets/f909cd0d-8713-4e7c-8b9d-9cde14b1db55" />

LSP Peek Definition
<img width="1366" height="768" alt="Image" src="https://github.com/user-attachments/assets/80f2c00f-1ec8-4ee2-a742-e3a3a0f907fc" />

File Picker (Snacks)
<img width="1366" height="768" alt="Image" src="https://github.com/user-attachments/assets/ea91167e-228a-49fb-b25b-16fc09527df9" />

Symbols Outline
<img width="1366" height="768" alt="Image" src="https://github.com/user-attachments/assets/21c800ff-dd25-4728-a9f6-8bea36fe06a7" />

Error Display
<img width="1366" height="768" alt="Image" src="https://github.com/user-attachments/assets/d5a6e02f-4c00-4337-83c4-defbd6cbbce4" />

Docs Hover
<img width="1366" height="768" alt="Image" src="https://github.com/user-attachments/assets/0314ab43-b5a9-46e9-acc0-e9103e42fa5d" />

Completion Menu
<img width="1366" height="768" alt="Image" src="https://github.com/user-attachments/assets/d3a19bcb-6a0f-471d-931b-f2c7b226209e" />

File Tree Explorer (NvimTree)
<img width="1366" height="768" alt="Image" src="https://github.com/user-attachments/assets/b32c6797-94b1-4822-8e75-8abe0302716e" />

File Manager (Yazi)
<img width="1366" height="768" alt="Image" src="https://github.com/user-attachments/assets/861a2ec5-4a5e-4d43-bd8d-c9107e24cd32" />

Floating Terminal
<img width="1366" height="768" alt="Image" src="https://github.com/user-attachments/assets/29c070c1-d0da-4a20-99a5-70869aabad19" />

Horizontal Terminal
<img width="1366" height="768" alt="Image" src="https://github.com/user-attachments/assets/3de1e62d-18fe-4c52-b52e-bcf408ca9102" />

Vertical Terminal
<img width="1366" height="768" alt="Image" src="https://github.com/user-attachments/assets/c5f95ca0-caba-4efa-9c08-6ff93e2be5e8" />

</details>

---

This repository is meant as a reference for me (and maybe for you too, to get inspiration) and to document my config.

[Keymaps](lua/configs/mappings/mappings.lua) are heavily configured and personalized.
This is to maintain consistency and compatibility with my _brain,_ Compositor/WM, TUI/GUI apps, Shell, Tmux/Terminal Emulator, etc.

---

## Install & Use:

> Only works on Linux (I think)

```bash
# Install & run
git clone https://github.com/r4ppz/nvZzz.git ~/.config/nvim && nvim

# inside, run
# :MasonInstallAll

# To uninstall
rm -rf ~/.config/nvim
rm -rf ~/.local/state/nvim
rm -rf ~/.local/share/nvim
```

Current Neovim version

```bash
❯ nvim -v

NVIM v0.12.2
Build type: RelWithDebInfo
LuaJIT 2.1.1774896198
```

## Languages & File Types Supported/Configured

> See [treesitter.lua](lua/plugins/treesitter.lua), [lsp.lua](lua/plugins/lsp.lua)
> and [servers/](lua/configs/servers/) for more info.

```ini
# Programming Languages (LSP + Treesitter + Formatter)
- C
- Go
- C++
- Lua
- Java
- Rust
- Python
- Assembly
- TypeScript
- JavaScript
- Bash
- Zsh
- SQL
- PHP

# Web & Frontend
- HTML
- Astro
- Svelte
- CSS/SCSS/Less
- React (JSX/TSX)
- Laravel (Blade)

# Config & Data Formats
- YAML
- JSON
- TOML
- XML
- Markdown
- Hyprland
- Docker/Docker Compose
- QML

# Editor & System (Treesitter only)
- Vim script, Vimdoc, Luadoc, printf, query
- INI, udev, ssh_config, tmux
- diff, git_config, gitcommit, git_rebase, gitignore, gitattributes
- regex, LaTeX
- More...
```

---

## Plugins Used:

Almost all plugins are lazy loaded, meaning they load only when used, not on startup.

This is why the startup time is under 1 second (`~15 milliseconds`); it's fast asf compared to VSCode or other IDEs.

| Plugin                                    | Description                                  |
| ----------------------------------------- | -------------------------------------------- |
| folke/lazy.nvim                           | Plugin manager (lazy loading)                |
| folke/snacks.nvim                         | Snacks plugin collection                     |
| nvchad/base46                             | NvChad theme plugin                          |
| nvchad/ui                                 | NvChad UI plugin                             |
| neovim/nvim-lspconfig                     | LSP configuration framework                  |
| nvim-treesitter/nvim-treesitter           | Better syntax parsing                        |
| mfussenegger/nvim-lint                    | Async linting engine                         |
| stevearc/conform.nvim                     | Code formatting engine                       |
| saghen/blink.cmp                          | Completion engine                            |
| L3MON4D3/LuaSnip                          | Snippet engine                               |
| rafamadriz/friendly-snippets              | Collection of snippets                       |
| williamboman/mason.nvim                   | Package manager for LSP/DAP/Linter/Formatter |
| williamboman/mason-lspconfig.nvim         | Auto-install LSP servers                     |
| jay-babu/mason-nvim-dap.nvim              | Auto-install DAP adapters                    |
| folke/trouble.nvim                        | Diagnostics and references list              |
| r4ppz/lspeek.nvim                         | Peek LSP Definitions                         |
| Bekaboo/dropbar.nvim                      | Winbar with breadcrumbs                      |
| hedyhli/outline.nvim                      | Symbols outline panel                        |
| lewis6991/gitsigns.nvim                   | Git signs in gutter                          |
| sindrets/diffview.nvim                    | Git diff viewer                              |
| CopilotC-Nvim/CopilotChat.nvim            | Copilot chat interface                       |
| mfussenegger/nvim-dap                     | Debug Adapter Protocol client                |
| rcarriga/nvim-dap-ui                      | DAP debugging interface                      |
| theHamsta/nvim-dap-virtual-text           | Inline variable display                      |
| jbyuki/one-small-step-for-vimkind         | Debug Neovim Lua code                        |
| windwp/nvim-autopairs                     | Auto-close brackets and quotes               |
| nvim-mini/mini.surround                   | Surround, delete, change pairs               |
| andymass/vim-matchup                      | Extended match navigation                    |
| lukas-reineke/indent-blankline.nvim       | Indent guide lines                           |
| chentoast/marks.nvim                      | Visual mark manager                          |
| RRethy/vim-illuminate                     | Highlight word under cursor                  |
| nvim-tree/nvim-tree.lua                   | File tree explorer                           |
| mikavilpas/yazi.nvim                      | File manager (Yazi)                          |
| MagicDuck/grug-far.nvim                   | Find and Replace via rg/ast-grep             |
| folke/which-key.nvim                      | Keymap popup helper                          |
| MeanderingProgrammer/render-markdown.nvim | Improve viewing markdown                     |
| zbirenbaum/copilot.lua                    | Copilot integration                          |
| nvim-lua/plenary.nvim                     | Lua utility functions                        |
| nvim-neotest/nvim-nio                     | Async IO library                             |
| nvim-tree/nvim-web-devicons               | Nerd font icons                              |
