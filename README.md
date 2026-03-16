# My Personal Neovim Configuration

> [!WARNING]
> This configuration will probably not work for you. I basically created my own editor and development environment (IDE). This
> is not idiomatic or follows neovim/vim philosophy. I use a lot of plugins and arrow keys just because neovim let me :p

---

<img src="img/startup.png" >

<img src="img/highlight.png" >

<img src="img/highlight2.png" >

<details>
<summary>More screenshots</summary>

> Some of the things I liked:

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
| <img src="img/error.png" /><br><sub>Error Display</sub>                 |                                                                             |

</details>

---

The [keybinds](lua/configs/mappings/custom.lua) aren't really Vim-idiomatic since I use a lot of arrow keys, some weird combinations like Ctrl+Shift+ArrowKey, and also a lot of the Alt key. I also unbound some defaults like macros, etc. I basically recreated the way normal GUI editors do it like Ctrl+Left to skip a word etc. Then added my own (other vim features) that I think are ergonomic and fit perfectly with my keyboard layout.

The tmux/hyprland/waybar config can be found in this repo: [Arch-dotfiles](https://github.com/r4ppz/Arch-dotfiles)

## Plugins used:

> it's a lot 😬 though I am still cleaning up and optimizing my workflow.

Startup time is still under 1 second (`~23 milliseconds`), so it's super fast compared to VSCode or typical IDEs.

```bash
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
