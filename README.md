# My Personal Neovim Configuration

_UI powered by [NvChad](https://nvchad.com/)_

![Neovim Startup](img/startup.png)

![Neovim Highlight](img/highlight1.png)

![Neovim Highlight](img/highlight2.png)

---

<details>
<summary>Features & more screenshots</summary>

> This is just some of the many features

AI Integration (Copilot)
![AI Integration (Copilot)](img/ai.png)

AI Predefined [Prompts](lua/configs/prompts.lua)
![AI Prompts](img/prompts.png)

Git Client (LazyGit)
![Git Client](img/git-client.png)

Git DiffView
![Git DiffView](img/diff.png)

Git Inline Diff
![Git Inline Diff](img/inline-diff.png)

Docker Integration (LazyDocker)
![Docker Integration](img/docker.png)

LSP References
![LSP References](img/references.png)

LSP Peek Definition
![LSP Peek Definition](img/peek-definition.png)

File Picker (Snacks)
![File Picker](img/picker.png)

Symbols Outline
![Symbols Outline](img/outline.png)

Error Display
![Error Display](img/error.png)

Docs Hover
![Docs Hover](img/hover.png)

Completion Menu
![Completion Menu](img/cmp.png)

File Manager (NvimTree)
![File Manager](img/file-manager.png)

File Manager 2 (Yazi)
![Yazi File Manager](img/yazi.png)

Floating Terminal
![Floating Terminal](img/floating-terminal.png)

Horizontal Terminal
![Horizontal Terminal](img/horizontal-terminal.png)

Vertical Terminal
![Vertical Terminal](img/vertical-terminal.png)

</details>

---

This repository is meant as a reference for me (for you too, to get inspiration maybe?) and to document my config.

[Keybinds](lua/configs/mappings/mappings.lua) are heavily configured and personalized.
This is to maintain consistency and compatibility with my compositor/WM, shell, terminal emulator, tmux, TUI apps, etc.

Tmux/Hyprland/Waybar config can be found in this repo: [Arch-dotfiles](https://github.com/r4ppz/Arch-dotfiles)

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

NVIM v0.12.1
Build type: RelWithDebInfo
LuaJIT 2.1.1774896198
```

## Languages & File Types Supported/Configured

I mostly work on config files and scripting (`Lua`/`sh`), as well as frontend and backend development
(`React`, `CSS`, `TS`, `Java`) for schoolwork and learning purposes.

My setup is great for fullstack development.

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

# Web & Frontend
- HTML
- Astro
- Svelte
- CSS/SCSS/Less
- React (JSX/TSX)

# Config & Data Formats
- YAML
- JSON
- TOML
- XML
- Markdown
- Hyprland
- Docker/Docker Compose

# Editor & System (Treesitter only)
- Vim script, Vimdoc, Luadoc, printf, query
- INI, udev, ssh_config, tmux
- diff, git_config, gitcommit, git_rebase, gitignore, gitattributes
- regex, LaTeX
- More...
```

---

## Plugins Used:

> it's a lot 😬 though I am still cleaning up and optimizing my workflow.

Startup time is still under 1 second (`~23 milliseconds`), so it's super duper fast compared to VSCode or typical IDEs.

Almost all plugins are lazy loaded, meaning they load only when used, not on startup.
So having many plugins is not really that big of a deal.

```
- folke/lazy.nvim
- nvchad/base46
- nvchad/ui
- nvzone/volt
- nvzone/menu
- neovim/nvim-lspconfig
- williamboman/mason.nvim
- williamboman/mason-lspconfig.nvim
- antosha417/nvim-lsp-file-operations
- nvimdev/lspsaga.nvim
- pmizio/typescript-tools.nvim
- mfussenegger/nvim-jdtls
- mfussenegger/nvim-lint
- stevearc/conform.nvim
- nvim-treesitter/nvim-treesitter
- chentoast/marks.nvim
- hrsh7th/nvim-cmp
- L3MON4D3/LuaSnip
- hrsh7th/cmp-nvim-lsp
- hrsh7th/cmp-nvim-lua
- saadparwaiz1/cmp_luasnip
- hrsh7th/cmp-buffer
- FelipeSSantos/cmp-async-path
- rafamadriz/friendly-snippets
- windwp/nvim-autopairs
- nvim-mini/mini.surround
- andymass/vim-matchup
- lukas-reineke/indent-blankline.nvim
- RRethy/vim-illuminate
- nvim-tree/nvim-tree.lua
- mikavilpas/yazi.nvim
- folke/snacks.nvim
- lewis6991/gitsigns.nvim
- sindrets/diffview.nvim
- zbirenbaum/copilot.lua
- CopilotC-Nvim/CopilotChat.nvim
- nvim-pack/nvim-spectre
- iamcco/markdown-preview.nvim
- MeanderingProgrammer/render-markdown.nvim
- nvimdev/dashboard-nvim
- Bekaboo/dropbar.nvim
- hedyhli/outline.nvim
- lewis6991/hover.nvim
- folke/which-key.nvim
- nvim-tree/nvim-web-devicons
- chrishrb/gx.nvim
- folke/todo-comments.nvim
- nvim-lua/plenary.nvim
```
