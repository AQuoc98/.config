# Ken's dotfiles

## Contents

- vim (Neovim) config
- tmux config
- git config
- fish config
- iterm2 config
- zsh config

## How to Use

1. Clone repo to .config folder in your mac
2. Install tmux, nvim, git, fish, ... by brew

## Neovim setup

### Requirements

- Brew
- Neovim >= **0.9.0** (needs to be built with **LuaJIT**)
- Git >= **2.19.0** (for partial clones support)
- [LazyVim](https://www.lazyvim.org/)
- a [Nerd Font](https://www.nerdfonts.com/)(v3.0 or greater) **_(optional, but needed to display some icons)_**
- [lazygit](https://github.com/jesseduffield/lazygit) **_(optional)_**
- a **C** compiler for `nvim-treesitter`. See [here](https://github.com/nvim-treesitter/nvim-treesitter#requirements)
- for [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) **_(optional)_**
  - **live grep**: [ripgrep](https://github.com/BurntSushi/ripgrep)
  - **find files**: [fd](https://github.com/sharkdp/fd)
- a terminal that support true color and *undercurl*:
  - [iterm2](https://iterm2.com/) **_(Macos)_**
- [Solarized Osaka](https://github.com/craftzdog/solarized-osaka.nvim)

## Shell setup (macOS & Linux)

- [Fish shell](https://fishshell.com/)
- [Fisher](https://github.com/jorgebucaran/fisher) - Plugin manager
- [Tide](https://github.com/IlanCosman/tide) - Shell theme
- [Nerd fonts](https://github.com/ryanoasis/nerd-fonts) - Patched fonts for development-use. I use BlexMono.
  - brew search nerd-font
- [z for fish](https://github.com/jethrokuan/z) - Directory jumping
- [Eza](https://github.com/eza-community/eza) - `ls` replacement
- [fzf](https://github.com/PatrickF1/fzf.fish) - Interactive filtering
- [nvm](https://github.com/jorgebucaran/nvm.fish) - Nvm for fish

## ZSH setup

- CLI
  - zsh-autosuggestions
  - zsh-syntax-highlighting
  - fzf
  - fd
  - bat
  - eza
  - zoxide
- Prompt: starship

## Command

### Shell

- Fish reload config: `source path-to-config.fish`
- List: `ls`, `la`, `ll`, `lla`
- Git: `g`
- Nvim: `v`
- Lazygit: `lazygit`
- Fzf
  - `<C-f>`: fzf change directory
  - `<C-o>`: open fzf
  - `<C-r>`: history command
  - `history clear`: clear search history
- [Z usage](https://github.com/jethrokuan/z/blob/master/man/man1/z.md)

### Terminal - zsh

- [Cheat Sheet](https://github.com/0nn0/terminal-mac-cheatsheet)
- List: `ls`, `ll`
- Default
  - `c`: clear
- Fzf
  - Type `fzf` or press `<C-t>`: get a list of files and directories
    - `<C-c`: quit mode
    - `<C-j>` or `<C-k`: move down / up
    - `<Tab>` or `<S-Tab`: mark multiple items
    - `<C-/`: change preview window
  - `COMMAND [DIRECTORY/][FUZZY_PATTERN]**<Tab>`
  - `<C-r`: paste the selected command from history onto the command-line
  - `<ALT-c>`: get a list of directories
- Zoxide

  - Use `z` to move
  - `z <Tab>`: show different possible directories

- Lazygit: `lg`

### VIM in VSCODE

- Cheat sheet

  - https://github.com/VSCodeVim/Vim/blob/master/ROADMAP.md
  - https://vim.rtorr.com/
  - https://www.barbarianmeetscoding.com/boost-your-coding-fu-with-vscode-and-vim/cheatsheet

- Default

  - `leader = space`
  - `x`: delete not yank
  - `jk`: exit insert mode
  - visual - `< || >`: stay in indent mode
  - visual - `J || K`: move line up and down
  - `<leader>v`: split window vertically
  - `<leader>s`: split window horizontally
  - `<C-h> || <C-j> || <C-k> || <C-l>`: navigate between split
  - `jk`: quit insert mode
  - `<Tab>`: tab previous
  - `<S-Tab>`: tab next
  - `C-n`: clear search highlight
  - `<leader>p`: format
  - `<C-z>`: toggle zen mode

- LSP

  - `gd`: go to definition
  - `gpd`: peek definition
  - `K`: show hover
    - `h j k l`: scroll when hover
  - `gi`: go to implementations
  - `gpi`: peek implementations
  - `gq`: quick fix (open the code action menu)
  - `gr`: go to references
  - `gs`: rename
  - `gt`: go to type definition
  - `gpt`: peek type definition
  - `[d || ]d`: show diagnostic

- Finder

  - `<Command-p>`: Go to file
  - `<C-n>` || `<C-p>`: move next or previous

- Suggestion

  - `C-c`: toggle suggestion
  - `<C-n>` || `<C-p>`: move next or previous

- File Explore

  - `<C-e>`: toggle open
  - `n`: new file
  - `r`: rename file
  - `<S-n`: new folder
  - `d`: delete file

- Terminal
  - `Cmd-J`: toggle terminal visibility
  - `<C-;>`: switch between terminal and active editor
  - `<C-S-;>`: maximize/minimize terminal panel and focus terminal
  - `<C-S-j>`: focus next terminal
  - `<C-S-k>`: focus previous terminal
  - `<C-S-n>`: new terminal
  - `<C-S-w>`: kill terminal

### Tmux

- [Cheat Sheet](https://tmuxcheatsheet.com/)
- Prefix: `<C-t>`
  - `r`: reload
  - `o`: open folder in finder
  - `e`: close all panes but current
  - `h j k l`: pane switching like vim
  - `<C-k>`, `<C-j>`, `<C-h>`, `<C-l>`: resize pane
  - `g`: open lazygit
- Moving window (swap): `<C-S-Left>`, `<C-S-Right>`

### Nvim

- [Cheat Sheet](https://vim.rtorr.com/)
- [LazyVim keymaps](https://www.lazyvim.org/keymaps)
- Default keymaps
  - `:Noice`: check the error message
  - `jk`: quit insert mode
  - `+`,`-`: increment, decrement
  - `dw`: delete a word backwards
  - `<C-a>`: select all
  - `<C-m>`, `<C-o>`, or use `[` , `]`: move backwards/forwards (jump list)
  - `<leader>d`, `<leader>c`, `<leader>p`: save and get from new yarn
  - `<leader>r`: replace hex color to hsl
  - Tab
    - `te`: open new tab
    - `<Tab>`: tab next
    - `<S-Tab>`: tab back
  - Window
    - `ss`: horizontal split
    - `sv`: vertical split
    - `sh`, `sk`, `sj`, `sl`: move window
    - `<C-w><left>`, `<C-w><right>`, `<C-w><up>`, `<C-w><down>`: resize window
  - Diagnostic
    - `<C-j>`>: go to next
- Telescope
  - `<leader>fP`: find plugin file
  - `;f`: lists files in your current working directory, respects .gitignore
  - `;r`: search for a string in your current working directory and get results live as you type, respects .gitignore
  - `\\\\`: lists open buffers
  - `;t`: lists available help tags and opens a new window with the relevant help info on <cr>
  - `;;`: resume the previous telescope picker
  - `;e`: lists Diagnostics for all open buffers or a specific buffer
  - `;s`: lists Function names, variables, from Treesitter
  - `sf`: open file browser with the path of the current buffer
    - normal mode
      - `N`: create file/folder
      - `h`: go to parent directory
      - `/`: start to search
      - `<C-u>`, `<C-d>`: move selection
      - `<PageUp>`, `<PageDown>`: preview scroll
- Neogen Comment: `<leader>cc`
- Refactoring: `<leader>r` - visual mode
- Symbols outline: `<leader>cs`
- Completion
  - `<C-space>`: show completion
  - `<C-b>`, `<C-f>`: scroll docs
  - `<C-e>`: abort
  - `<CR>`: confirm
- LSP
  - `<leader>i`: toggle inlay hints
- Git
  - `<leader>gb`: open blame window
  - `<leader>go`: open file/folder in git repo
  - `<leader>lg`: open lazygit
- Zen mode: `<leader>z`
