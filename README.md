# My Personal Neovim Configuration

<img src="img/startup.png" >

<img src="img/highlight1.png" >

<img src="img/highlight2.png" >

<details>
<summary>Some of the features I liked</summary>

|                                                                         |                                                                             |
| ----------------------------------------------------------------------- | --------------------------------------------------------------------------- |
| <img src="img/ai.png" /><br><sub>Copilot AI</sub>                       | <img src="img/prompts.png" /><br><sub>AI Prompts</sub>                      |
| <img src="img/git-client.png" /><br><sub>LazyGit</sub>                  | <img src="img/docker.png" /><br><sub>LazyDocker</sub>                       |
| <img src="img/peek-definition.png" /><br><sub>Peek Definition</sub>     | <img src="img/hover.png" /><br><sub>Hover</sub>                             |
| <img src="img/references.png" /><br><sub>References</sub>               | <img src="img/cmp.png" /><br><sub>Completion Menu</sub>                     |
| <img src="img/picker.png" /><br><sub>Picker</sub>                       | <img src="img/horizontal-terminal.png" /><br><sub>Horizontal Terminal</sub> |
| <img src="img/floating-terminal.png" /><br><sub>Floating Terminal</sub> | <img src="img/vertical-terminal.png" /><br><sub>Vertical Terminal</sub>     |
| <img src="img/diff.png" /><br><sub>DiffView</sub>                       | <img src="img/inline-diff.png" /><br><sub>Inline Diff</sub>                 |
| <img src="img/outline.png" /><br><sub>Symbols Outline</sub>             | <img src="img/file-manager.png" /><br><sub>File Manager</sub>               |
| <img src="img/error.png" /><br><sub>Error Display</sub>                 | <img src="img/yazi.png" /><br><sub>Yazi</sub>                               |

</details>

This repository is meant as a reference for me (for you too, to get inspiration maybe?) and to document my config.

[Keybinds](lua/configs/mappings/) are heavily configured and personalized. Many arrow-keys, alt-keys, and non-defaults are used.
This is to maintain consistency and compatibility with my compositor/WM, Shell, GUI programs, Tmux workflow, etc.

Tmux/Hyprland/Waybar config can be found in this repo: [Arch-dotfiles](https://github.com/r4ppz/Arch-dotfiles)

---

### Install & Use:

> I don't use Windows so this will probably not work well in there.

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

## Plugins used:

> it's a lot 😬 though I am still cleaning up and optimizing my workflow.

Startup time is still under 1 second (`~23 milliseconds`), so it's super duper fast compared to VSCode or typical IDEs.

Almost all plugins are lazy loaded, meaning they load only when used, not on startup.
So having many plugins is not really that big of a deal.

_UI powered by [NvChad](https://nvchad.com/)_

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
- NStefan002/screenkey.nvim
- folke/todo-comments.nvim
- nvim-lua/plenary.nvim
```

### Tree-sitter Parsers

Parsers that understand code structure, mainly used for syntax highlighting, text objects, folding, and other syntax-aware features.

Defined in [treesitter.lua](lua/plugins/treesitter.lua)

```
- luadoc
- printf
- vim
- vimdoc
- markdown
- latex
- markdown_inline
- query
- sql
- lua
- bash
- java
- rust
- python
- c
- asm
- cpp
- hyprlang
- go
- gomod
- gowork
- gosum
- yaml
- toml
- xml
- json
- html
- css
- javascript
- typescript
- tsx
- diff
- git_config
- gitcommit
- git_rebase
- gitignore
- gitattributes
- regex
```

### LSP Servers

Language-aware backends that provide references, go-to-definition, diagnostics, autocomplete,
and most of what makes the editor feel like an IDE via the [Language Server Protocol](https://microsoft.github.io/language-server-protocol/).

Configured in [lsp.lua](lua/plugins/lsp.lua) and [servers.lua](lua/configs/servers.lua).

```
- html
- cssls
- jsonls
- yamlls
- marksman
- eslint
- cssmodules_ls
- css_variables
- jdtls
- docker_language_server
- dockerls
- lemminx
- postgres_lsp
- gopls
- taplo
- lua_ls
- pyright
- bashls
- rust_analyzer
- hyprls
- clangd
- asm_lsp
```
