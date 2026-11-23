# Homebrew (only if installed; brew isn't on PATH until shellenv runs, so check known locations)
for brew_bin in /home/linuxbrew/.linuxbrew/bin/brew "$HOME/.linuxbrew/bin/brew" /opt/homebrew/bin/brew /usr/local/bin/brew; do
    if [ -x "$brew_bin" ]; then
        eval "$("$brew_bin" shellenv)"
        break
    fi
done
unset brew_bin

# PATH
# Rust / cargo (only if installed)
typeset -gU path   # keep PATH free of duplicates (-g: this file is sourced inside a function)
[ -d "$HOME/.cargo/bin" ] && path=("$HOME/.cargo/bin" $path)
