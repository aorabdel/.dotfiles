# ls aliases
alias ls='ls --color=auto -h'
alias ll='ls -alFh --color=auto'
alias la='ls -Ah --color=auto'
alias l='ls -CFh --color=auto'

alias python='python3'
alias vi=vim

alias lld="df -h | sed -n '1p;/mapper/p'"
alias lls="du -csh * | sort -hr"
alias lg='lazygit'
alias g='git'
alias vi=vim
alias v=nvim
alias grep='grep --color=always'

alias ...='../..'
alias ....='../../..'
alias .....='../../../..'
alias ......='../../../../..'

alias zrc='nvim $ZRC'
alias update='sudo apt update && sudo apt upgrade -y'
alias cpf='xclip -selection clipboard <'
alias clip='xclip -selection clipboard -i'
alias clipo='xclip -selection clipboard -o'

# Docker
alias dprune='docker system prune -af'
alias dcls='docker ps -a'
alias dils='docker image ls'

# Quick git - shorter than .git config aliases
alias gl='git log --oneline'
alias gs='git status'
alias gb='git branch'
alias gbd='git branch -D'
alias gco='git checkout'
alias gc='git commit --allow-empty -m'
alias gp='git pull origin $(git rev-parse --abbrev-ref HEAD)'
alias gP='git push origin $(git rev-parse --abbrev-ref HEAD)'
alias gPF='git push -f origin $(git rev-parse --abbrev-ref HEAD)'
alias gP='git push origin $(git rev-parse --abbrev-ref HEAD)'
alias gf='git fetch --prune'
alias gfp='git fetch --all --tags && git pull'
