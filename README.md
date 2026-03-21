# My Personal Neovim Configuration

> [!WARNING]
> This configuration will probably not work for you. I basically created my own editor/development environment (IDE).
> This is not idiomatic or follows neovim/vim philosophy. I use a lot of plugins and arrow keys just because neovim let me :p

---

<img src="img/startup.png" >

<img src="img/highlight1.png" >

<img src="img/highlight2.png" >

<details>
<summary>Some of the features I liked</summary>

> click the link to see where is it configured.

|                                                                                                             |                                                                                                                 |
| ----------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------- |
| <img src="img/ai.png" /><br><sub>[Copilot AI](lua/plugins/copilot.lua)</sub>                                | <img src="img/prompts.png" /><br><sub>[AI Prompts](lua/configs/prompts.lua)</sub>                               |
| <img src="img/git-client.png" /><br><sub>[LazyGit](lua/plugins/git.lua)</sub>                               | <img src="img/docker.png" /><br><sub>[LazyDocker](lua/configs/mappings/plugins.lua)</sub>                       |
| <img src="img/peek-definition.png" /><br><sub>[Peek Definition](lua/configs/mappings/lsp.lua)</sub>         | <img src="img/hover.png" /><br><sub>[Hover](lua/plugins/hover.lua)</sub>                                        |
| <img src="img/references.png" /><br><sub>[References](lua/configs/mappings/lsp.lua)</sub>                   | <img src="img/cmp.png" /><br><sub>[Completion Menu](lua/plugins/cmp.lua)</sub>                                  |
| <img src="img/picker.png" /><br><sub>[Picker](lua/plugins/snacks.lua)</sub>                                 | <img src="img/horizontal-terminal.png" /><br><sub>[Horizontal Terminal](lua/configs/mappings/plugins.lua)</sub> |
| <img src="img/floating-terminal.png" /><br><sub>[Floating Terminal](lua/configs/mappings/plugins.lua)</sub> | <img src="img/vertical-terminal.png" /><br><sub>[Vertical Terminal](lua/configs/mappings/plugins.lua)</sub>     |
| <img src="img/diff.png" /><br><sub>[DiffView](lua/plugins/git.lua)</sub>                                    | <img src="img/inline-diff.png" /><br><sub>[Inline Diff](lua/plugins/git.lua)</sub>                              |
| <img src="img/outline.png" /><br><sub>[Symbols Outline](lua/plugins/outline.lua)</sub>                      | <img src="img/file-manager.png" /><br><sub>[File Manager](lua/plugins/nvim_tree.lua)</sub>                      |
| <img src="img/error.png" /><br><sub>[Error Display](lua/configs/mappings/lsp.lua)</sub>                     | <img src="img/yazi.png" /><br><sub>[Yazi](lua/plugins/yazi.lua)</sub>                                           |

</details>

This repository is meant as a reference for me (for you too, to get inspiration maybe?) and to document my config.

Keybinds are heavily configured and personalized. Many arrow-keys, alt-keys, and non-defaults are used.
This is to maintain consistency with my compositor/WM, Shell, GUI programs, Tmux workflow, etc.

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
So having many plugins is not really that big of a deal imo.

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
- taplo
- lua_ls
- pyright
- bashls
- rust_analyzer
- hyprls
- clangd
- asm_lsp
```
