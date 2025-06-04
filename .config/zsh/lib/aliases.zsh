# ls aliases
alias ls='ls --color=auto -h'
alias ll='ls -alFh --color=auto'
alias la='ls -Ah --color=auto'
alias l='ls -CFh --color=auto'
alias python='python3'

alias ...='../..'
alias ....='../../..'
alias .....='../../../..'
alias ......='../../../../..'

alias zrc='nvim $ZRC'
alias update='sudo apt update && sudo apt upgrade -y'

# Docker
alias dprune='docker system prune -af'
alias dcls='docker ps -a'
alias dils='docker image ls'
