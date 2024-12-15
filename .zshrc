export ZSH="/run/current-system/sw/share/oh-my-zsh"
source $ZSH/oh-my-zsh.sh

eval "$(zoxide init zsh)"
ZSH_TMUX_AUTOSTART=true
ZOXIDE_CMD_OVERRIDE=cd
