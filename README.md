# My Personal Neovim Configuration

_UI powered by [NvChad](https://nvchad.com/)_

![Neovim Startup](img/startup.png)

![Neovim Highlight](img/highlight1.png)

![Neovim Highlight](img/highlight2.png)

---

<details>
<summary>Features & more screenshots</summary>

> These are just some of the many features

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
So having many plugins is not really that big of a deal.

This is why the startup time is under 1 second (`~23 milliseconds`); it's fast asf compared to VSCode or other IDEs.

```ini
- folke/lazy.nvim
- nvchad/base46
- nvchad/ui
- neovim/nvim-lspconfig
- williamboman/mason.nvim
- williamboman/mason-lspconfig.nvim
- folke/trouble.nvim
- r4ppz/lspeek.nvim
- mfussenegger/nvim-lint
- stevearc/conform.nvim
- nvim-treesitter/nvim-treesitter
- chentoast/marks.nvim
- saghen/blink.cmp
- L3MON4D3/LuaSnip
- rafamadriz/friendly-snippets
- windwp/nvim-autopairs
- nvim-mini/mini.surround
- andymass/vim-matchup
- lukas-reineke/indent-blankline.nvim
- nvim-tree/nvim-tree.lua
- mikavilpas/yazi.nvim
- folke/snacks.nvim
- lewis6991/gitsigns.nvim
- sindrets/diffview.nvim
- zbirenbaum/copilot.lua
- CopilotC-Nvim/CopilotChat.nvim
- nvim-pack/nvim-spectre
- nvimdev/dashboard-nvim
- Bekaboo/dropbar.nvim
- RRethy/vim-illuminate
- hedyhli/outline.nvim
- folke/which-key.nvim
- nvim-tree/nvim-web-devicons
- nvim-lua/plenary.nvim
```
