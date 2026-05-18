# Sourcing
alias source-all="source ~/.bash_aliases && tmux source-file ~/.tmux.conf"

# Vim
alias vim="nvim"
alias vimd="nvim -d"

# Tmux
alias tx="tmux"
alias txl="tmux ls"
alias txs="tmux new -s "
alias txa="tmux a -t "
alias txk="pkill tmux"

# Python
alias py='python3'

# Git
alias gs="git status"
alias ga="git add ."
alias gc="git commit -m "
alias gp="git push origin "
alias gf="git fetch"

# Functions
mkcd() { mkdir -p "$1" && cd "$1"; }

# Utilities
alias wd='echo /mnt/c/Users/'
