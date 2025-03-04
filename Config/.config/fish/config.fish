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

    # Set up fzf key bindings
    fzf --fish | source
    set -x FZF_DEFAULT_COMMAND "fd --type f --strip-cwd-prefix --hidden --follow --exclude .git --exclude node_modules"

    fish_vi_key_bindings
    bind -M insert \cf "sh ~/.config/hypr/scripts/tmux-sessionizer.sh"
    bind -M insert \cn "sh ~/.config/hypr/scripts/search-notes.sh"

    alias ls="exa --icons"
    alias la="exa --icons -a"
    alias lla="exa --icons -l -a"
    alias lst="exa -l -g -T --icons -L=2"
    alias ll="exa -l -g --icons"

    alias g="git"

    alias vim="nvim"

    set -gx EDITOR nvim
end
