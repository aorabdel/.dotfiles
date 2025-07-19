ZSH_CONFIG_DIR="$HOME/.config/zsh"
ZRC="$HOME/.zshrc"
[ -f "${ZSH_CONFIG_DIR}/lib/functions.zsh" ] && source "${ZSH_CONFIG_DIR}/lib/functions.zsh"

zsh_set_prompt path_git

# History in cache directory:
HISTSIZE=10000000
SAVEHIST=10000000
mkdir -p "$HOME/.cache/zsh"
HISTFILE="$HOME/.cache/zsh/.history"
setopt HIST_FIND_NO_DUPS
setopt INC_APPEND_HISTORY

# Set Options
setopt autocd		            # Automatically cd into typed directory.
stty stop undef		            # Disable ctrl-s to freeze terminal.
zle_highlight=('paste:none')    # Disable paste highlight

# Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)		# Include hidden files.

# Plugins
zsh_add_plugin "zsh-users/zsh-syntax-highlighting"
zsh_add_plugin "zsh-users/zsh-autosuggestions"
zsh_add_plugin "zsh-users/zsh-history-substring-search"
zsh_add_plugin "joshskidmore/zsh-fzf-history-search"

zsh_add_file "lib/aliases.zsh"
zsh_add_file "lib/exports.zsh"
zsh_add_file "lib/keybinds.zsh"
zsh_add_file "lib/startup.zsh"

# Tmux plugins
tmux_add_plugin "tmux-plugins/tpm"
tmux_add_plugin "christoomey/vim-tmux-navigator"
