#
# ~/.bashrc
#

# If not running interactively, don"t do anything
[[ $- != *i* ]] && return
scriptsDir="$HOME/.local/scripts"
export EDITOR=nvim
export PATH="${PATH}:$HOME/.local/bin"

eval "$(starship init bash)"
eval "$(fzf --bash)"
eval "$(zoxide init bash)"
set -o vi

bind 'TAB:menu-complete'
bind -x '"\C-f":"${scriptsDir}/tmux-sessionizer.sh"'
bind -x '"\C-v":"vim $(fzf)"'

alias ls="ls --color=auto"
alias grep="grep --color=auto"
alias vim="nvim"

alias ls="exa --icons"
alias la="exa --icons -a"
alias lla="exa --icons -l -a"
alias lst="exa -l -g -T --icons -L=2"
alias ll="exa -l -g --icons"

alias g="git"
alias gc="git clone"

# Move to the parent folder.
alias ..='cd ..;pwd'
# Move up two parent folders.
alias ...='cd ../..;pwd'
# Move up three parent folders.
alias ....='cd ../../..;pwd'

PS1="[\u@\h \W]\$ "
