set fish_greeting ""

set -gx TERM xterm-256color

set -Ux EDITOR nvim

# theme
set -g theme_color_scheme terminal-dark
set -g fish_prompt_pwd_dir_length 1
set -g theme_display_user yes
set -g theme_hide_hostname no
set -g theme_hostname always

# aliases
alias ls "ls -p -G"
alias la "ls -A"
alias ll "ls -l"
alias lla "ll -A"
alias g git
alias v nvim
alias ol ollama
alias c clear
alias lg lazygit

# Yazi
function y
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    yazi $argv --cwd-file="$tmp"
    if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
        builtin cd -- "$cwd"
    end
    rm -f -- "$tmp"
end

# Brew
eval (/opt/homebrew/bin/brew shellenv)
set -gx HOMEBREW_NO_AUTO_UPDATE 1

# NVM
set --universal nvm_default_version latest

# Flutter
set -g FLUTTERPATH $HOME/development/flutter
set -gx PATH $FLUTTERPATH/bin $PATH

function flutter-watch
    tmux send-keys "flutter run $argv[1] $argv[2] $argv[3] $argv[4] --pid-file=/tmp/tf1.pid" Enter
    tmux split-window -v
    tmux send-keys 'npx -y nodemon -e dart -x "cat /tmp/tf1.pid | xargs kill -s USR1"' Enter
    tmux resize-pane -y 5 -t 1
    tmux select-pane -t 0
end

# Dart
set -g DARTPATH $HOME/development/flutter
set -gx PATH $DARTPATH/bin/dart $PATH

# Ruby version manager rbenv
eval "$(rbenv init -)"

switch (uname)
    case Darwin
        source (dirname (status --current-filename))/config-osx.fish
    case Linux
        source (dirname (status --current-filename))/config-linux.fish
end
