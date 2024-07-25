set -g fish_greeting

if status is-interactive
    starship init fish | source
    fish_vi_key_bindings

    alias vadim='$HOME/.config/hypr/scripts/vadim.sh'
    alias ls="exa --icons"
    alias lla="exa --icons -a"
    alias lst="exa -l -g -T --icons -L=2"
    alias ll="exa -l -g --icons"

    alias g="git"
    alias gc="git clone"
    alias gcm="git commit"
    alias gst="git status"
    alias gck="git checkout"

    alias vim="nvim"
    alias zj="zellij"

    set -gx EDITOR nvim
    set -Ux FZF_DEFAULT_OPTS "--color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9 --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9 --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6 --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4"

end
