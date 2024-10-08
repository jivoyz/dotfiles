set -g fish_greeting

if status is-interactive
    starship init fish | source
    zoxide init fish | source

    # Set up fzf key bindings
    fzf --fish | source

    fish_vi_key_bindings
    bind -M insert \cf "sh ~/.config/hypr/scripts/tmux-sessionizer.sh"
    bind -M insert \cn "sh ~/.config/hypr/scripts/search-notes.sh"

    alias vadim='$HOME/.config/hypr/scripts/vadim.sh'
    alias ls="exa --icons"
    alias la="exa --icons -a"
    alias lla="exa --icons -l -a"
    alias lst="exa -l -g -T --icons -L=2"
    alias ll="exa -l -g --icons"

    alias g="git"
    alias gc="git clone"
    alias gcm="git commit"
    alias gst="git status"
    alias gck="git checkout"

    alias vim="nvim"

    set -gx EDITOR nvim
    source ~/.config/fish/fzf.fish
  # set -Ux FZF_DEFAULT_OPTS "\
  # --color=bg+:#ccd0da,bg:#eff1f5,spinner:#dc8a78,hl:#d20f39 \
  # --color=fg:#4c4f69,header:#d20f39,info:#8839ef,pointer:#dc8a78 \
  # --color=marker:#7287fd,fg+:#4c4f69,prompt:#8839ef,hl+:#d20f39 \
  # --color=selected-bg:#bcc0cc \
  # --multi"

end
