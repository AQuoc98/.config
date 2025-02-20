# Config for ...

- Vim - Neovim
- Tmux
- Fish
- Iterm2
- zsh
- Warp
- Ghostty
- Yazi

# How to setup and use

1. Clone repo to .config folder in your mac
2. Install tmux, nvim, git, fish, ... by brew

## Neovim

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

## Shell

- [Fish shell](https://fishshell.com/)
- [Fisher](https://github.com/jorgebucaran/fisher) - Plugin manager
- [Tide](https://github.com/IlanCosman/tide) - Shell theme
- [Nerd fonts](https://github.com/ryanoasis/nerd-fonts) - Patched fonts for development-use. I use BlexMono.
  - brew search nerd-font
- [z for fish](https://github.com/jethrokuan/z) - Directory jumping
- [Eza](https://github.com/eza-community/eza) - `ls` replacement
- [fzf](https://github.com/PatrickF1/fzf.fish) - Interactive filtering
- [nvm](https://github.com/jorgebucaran/nvm.fish) - Nvm for fish

## ZSH

- CLI
  - zsh-autosuggestions
  - zsh-syntax-highlighting
  - fzf
  - fd
  - bat
  - eza
  - zoxide
- Prompt: starship

# Command & Keyboard Shortcut

## Shell

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

## Terminal - zsh

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

## Tmux

- [Cheat Sheet](https://tmuxcheatsheet.com/)
- Prefix: `<C-a>`

  - `r`: reload
  - `o`: open folder in finder
  - `e`: close all panes but current
  - `h j k l`: pane switching like vim
  - `<C-k>`, `<C-j>`, `<C-h>`, `<C-l>`: resize pane
  - `g`: open lazygit

- Moving window (swap): `<C-S-Left>`, `<C-S-Right>`

## Nvim

- [Cheat Sheet](https://vim.rtorr.com/)
- [LazyVim keymaps](https://www.lazyvim.org/)

- Commands

  - `WhichKey`: show key maps
  - `Noice`: show the system error message

- [Search and Replace](https://www.baeldung.com/linux/vim-search-replace)

## VIM in VSCODE

- Cheat sheet

  - https://github.com/VSCodeVim/Vim/blob/master/ROADMAP.md

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

- VIM Surround

  - `ds`: delete surroundings e.g. ds"
  - `cs`: change surroundings e.g. cs\*tem>
  - `ys`: add surroundings e.g. ysiw"
  - `ds"`: delete surrounding quotes
  - `cs*tem>`: change surrounding \* for the <em> tag
  - `ysiw"`: surround word under the cursor with quotes
  - `S`: In visual mode you can select some text, then type S to add surroundings. e.g. Stp> to wrap the selection in a <p> tag

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
