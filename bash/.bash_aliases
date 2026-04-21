# Vim
alias vim="nvim"
alias vimd="nvim -d"

# Tmux
alias tx="tmux"

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
alias todesktop="mkdir -p invoices && mv SES*.html SES*.pdf invoices && cp -r invoices/ /mnt/c/Users/csaen/OneDrive/Desktop/ && echo All Done!"
alias wind='echo /mnt/c/Users/csaen/'
