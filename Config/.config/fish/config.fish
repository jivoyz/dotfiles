set -g fish_greeting

# fzf.fish
# CTRL + ALT + L - Git log
# CTRL + ALT + G - Git status
# CTRL + ALT + F - Search directory
# CTRL + R - Search history
# CTRL + ALT + P - Search processes
# CTRL + V - Search variables (fish)

if status is-interactive
    starship init fish | source
    zoxide init fish | source
    fish_add_path $HOME/.local/bin
    source ~/.config/fish/fzf.fish
    source ~/.config/fish/flexoki.fish # theme

    set fish_cursor_default block
    set fish_cursor_insert block

    # Set up fzf key bindings
    fzf --fish | source

    fish_vi_key_bindings
    bind -M insert \cf "sh ~/.local/scripts/tmux-sessionizer.sh"
    bind -M insert \cn "sh ~/.local/scripts/search-notes.sh"


    alias ls="eza --icons"
    alias la="eza --icons -a"
    alias lla="eza --icons -l -a"
    alias lst="eza -l -g -T --icons -L=2"
    alias ll="eza -l -g --icons"

    alias g="git"

    alias vim="nvim"

    set -gx EDITOR nvim
    set -gx MANPAGER "nvim +Man!"
end
