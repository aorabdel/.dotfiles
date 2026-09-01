# Bootstrap this dotfiles repo on a fresh Arch Linux install.
#
#   make            # everything, in dependency order
#   make packages   # pacman packages from packages/arch.txt
#   make check      # verify an existing setup
#
# Every rule is idempotent: re-running is a no-op once satisfied.

SHELL       := /bin/bash
.SHELLFLAGS := -eu -o pipefail -c

DOTFILES := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))
ZSH_LIB  := $(DOTFILES)/.config/zsh/lib
NVIM     := nvim --headless
TPM      := $(HOME)/.config/tmux/plugins/tpm
TS_DIR   := $(HOME)/.local/share/nvim/lazy/nvim-treesitter/parser

# Treesitter parsers are read out of the nvim config so this never drifts.
TS_PARSERS = $(shell awk '/ensure_installed = \{/{f=1;next} f&&/^\t*\}/{exit} \
	f&&/"/{gsub(/[^a-z_0-9]/,"");print}' $(DOTFILES)/.config/nvim/lua/plugins/editor.lua)

.PHONY: all packages shell stow unstow restow local systemd zsh tmux nvim vim check clean help

all: packages stow local systemd zsh tmux nvim vim
	@echo
	@echo "==> Done. Open a new shell, and point your terminal at JetBrainsMono Nerd Font."

help:
	@grep -hE '^[a-z-]+:.*##' $(MAKEFILE_LIST) | sed 's/:.*##/\t/' | column -t -s "$$(printf '\t')"

## ---------------------------------------------------------------- packages

packages: ## Install everything the configs reference
	@echo "==> pacman"
	sudo pacman -Syu --needed $$(tr '\n' ' ' < $(DOTFILES)/packages/arch.txt)

shell: ## Make zsh the login shell
	@if [ "$$(getent passwd $$USER | cut -d: -f7)" != "$$(command -v zsh)" ]; then \
		echo "==> chsh -s $$(command -v zsh)"; chsh -s "$$(command -v zsh)"; \
	else echo "==> login shell already zsh"; fi

## ---------------------------------------------------------------- symlinks

# NOTE: the stow dir is the repo and the package is ".". The intuitive
# `stow -d ~ -t ~ .dotfiles` is a SILENT NO-OP -- stow skips a target that is
# its own stow dir, warns, and exits 0 having linked nothing.
stow: ## Symlink the repo into $HOME (backs up conflicting real files)
	@echo "==> stow"
	@if [ -f "$(HOME)/.zshrc" ] && [ ! -L "$(HOME)/.zshrc" ]; then \
		echo "    backing up real ~/.zshrc -> ~/.zshrc.pre-stow.bak"; \
		mv "$(HOME)/.zshrc" "$(HOME)/.zshrc.pre-stow.bak"; \
	fi
	stow -v -d $(DOTFILES) -t $(HOME) .

unstow: ## Remove the symlinks
	stow -Dv -d $(DOTFILES) -t $(HOME) .

restow: ## Re-link (use after adding/removing tracked files)
	stow -Rv -d $(DOTFILES) -t $(HOME) .

## ---------------------------------------------------------------- machine-local

# Both files are gitignored. Written only if absent, so a re-run never
# clobbers machine-specific edits.
local: ## Seed local.zsh and ~/.gitconfig.local
	@echo "==> machine-local overrides"
	@if [ ! -f "$(ZSH_LIB)/local.zsh" ]; then \
		echo "    creating $(ZSH_LIB)/local.zsh"; \
		printf '%s\n' \
			'# --- machine-local: Arch / WSL2 (gitignored) ---' \
			'export PATH="$$HOME/.local/bin:$$HOME/go/bin:$$PATH"' \
			'export SSH_AUTH_SOCK="$$XDG_RUNTIME_DIR/ssh-agent.socket"' \
			'' \
			"alias xcopy='xclip -selection clipboard'" \
			"alias update='sudo pacman -Syu'" \
			> "$(ZSH_LIB)/local.zsh"; \
	else echo "    local.zsh exists, leaving alone"; fi
	@if [ ! -f "$(HOME)/.gitconfig.local" ]; then \
		echo "    creating ~/.gitconfig.local"; \
		printf '[user]\n    name = %s\n    email = %s\n' \
			"Abdelrahman Abdelraouf" "aorabdel@gmail.com" > "$(HOME)/.gitconfig.local"; \
	else echo "    .gitconfig.local exists, leaving alone"; fi

## ---------------------------------------------------------------- systemd

# Without linger the user manager only starts on a real login session. Under
# WSL that session frequently never establishes (a locked account password is
# enough to break it), so ssh-agent.socket never starts and the SSH_AUTH_SOCK
# exported in local.zsh points at a socket that does not exist.
systemd: ## Enable the user manager so ssh-agent.socket runs
	@echo "==> systemd user manager"
	@if ! loginctl show-user $$USER 2>/dev/null | grep -q '^Linger=yes'; then \
		sudo loginctl enable-linger $$USER; sleep 2; \
	fi
	systemctl --user enable --now ssh-agent.socket
	@systemctl --user is-active ssh-agent.socket

## ---------------------------------------------------------------- shell

# .zshrc clones missing plugins but does NOT source them in the same run, so
# the first shell comes up bare. Run it twice.
zsh: ## Clone zsh plugins + tmux tpm (via .zshrc's own bootstrap)
	@echo "==> zsh plugins (first run clones, second run sources)"
	-@zsh -i -c 'exit' 2>&1 | grep -v 'Inappropriate ioctl' || true
	@zsh -i -c 'type _zsh_autosuggest_start >/dev/null && echo "    autosuggestions active"' 2>/dev/null

tmux: ## Install tmux plugins non-interactively (no prefix+I needed)
	@echo "==> tmux plugins"
	@test -x $(TPM)/bin/install_plugins || { echo "tpm missing -- run 'make zsh' first"; exit 1; }
	@tmux new-session -d -s make-bootstrap 2>/dev/null || true
	$(TPM)/bin/install_plugins
	@tmux kill-session -t make-bootstrap 2>/dev/null || true

## ---------------------------------------------------------------- editors

# Four separate headless passes, because each needs the previous one finished:
#  1. restore plugins at the committed lazy-lock.json
#  2. build telescope-fzf-native's libfzf.so (needs base-devel)
#  3. compile parsers -- TSUpdateSync returns before its downloads finish, so
#     TSInstallSync with an explicit list is what actually completes them
#  4. mason: lspconfig is lazy-loaded, so force-load it before the installer
nvim: ## Restore plugins, build fzf-native, compile parsers, install LSPs
	@echo "==> neovim: plugins"
	$(NVIM) "+Lazy! restore" +qa </dev/null
	@echo "==> neovim: telescope-fzf-native"
	$(NVIM) "+Lazy! build telescope-fzf-native.nvim" +qa </dev/null
	@# TSInstallSync PROMPTS "already available: reinstall? y/n" for every parser
	@# that exists and then hangs forever headless, so only ask for missing ones.
	@echo "==> neovim: treesitter"
	@missing=""; for p in $(TS_PARSERS); do \
		test -f "$(TS_DIR)/$$p.so" || missing="$$missing $$p"; done; \
		if [ -n "$$missing" ]; then \
			echo "    installing:$$missing"; \
			$(NVIM) "+TSInstallSync $$missing" "+sleep 30" +qa </dev/null; \
		else echo "    all $(words $(TS_PARSERS)) parsers present"; fi
	@echo "==> neovim: mason tools"
	@# lspconfig is lazy-loaded, so force-load it before the installer runs.
	$(NVIM) "+Lazy! load nvim-lspconfig mason.nvim mason-tool-installer.nvim" \
		"+MasonToolsInstallSync" "+sleep 60" +qa </dev/null
	@ls $(HOME)/.local/share/nvim/mason/bin

# vim-plug is not vendored, and .vimrc's undodir is never created by anything.
vim: ## Install vim-plug and the .vimrc plugins
	@echo "==> vim"
	mkdir -p $(HOME)/.config/vim/tmp/undo
	@test -f $(HOME)/.vim/autoload/plug.vim || \
		curl -fsSLo $(HOME)/.vim/autoload/plug.vim --create-dirs \
			https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	@# NOTE: do NOT redirect stdout to /dev/null here -- vim-plug in silent-ex
	@# mode aborts without installing anything if its output has nowhere to go.
	vim -es -u $(HOME)/.vimrc -i NONE -c "PlugInstall --sync" -c qa </dev/null || true
	@ls $(HOME)/.vim/plugged

## ---------------------------------------------------------------- verify

check: ## Verify the setup
	@echo "==> binaries"
	@for c in stow nvim vim tmux fzf fd rg bat tree zoxide yazi lazygit node xclip; do \
		printf '    %-9s %s\n' "$$c" "$$(command -v $$c || echo MISSING)"; done
	@echo "==> symlinks"
	@for f in .zshrc .vimrc .gitconfig .config/nvim .config/tmux .config/yazi .config/zsh; do \
		test -L "$(HOME)/$$f" && printf '    ok   %s\n' "$$f" || printf '    MISS %s\n' "$$f"; done
	@test ! -e "$(HOME)/Brewfile" && echo "    ok   Brewfile not leaked into ~" || echo "    WARN Brewfile leaked into ~"
	@echo "==> git identity"
	@printf '    %s <%s>\n' "$$(git config --get user.name)" "$$(git config --get user.email)"
	@echo "==> ssh agent"
	@systemctl --user is-active ssh-agent.socket 2>/dev/null | sed 's/^/    socket: /'
	@ssh-add -l 2>&1 | sed 's/^/    /' || true
	@echo "==> plugins"
	@printf '    zsh:        %s\n' "$$(ls $(HOME)/.config/zsh/plugins 2>/dev/null | wc -l)"
	@printf '    tmux:       %s\n' "$$(ls $(HOME)/.config/tmux/plugins 2>/dev/null | wc -l)"
	@printf '    nvim:       %s\n' "$$(ls $(HOME)/.local/share/nvim/lazy 2>/dev/null | wc -l)"
	@printf '    parsers:    %s / %s\n' \
		"$$(ls $(HOME)/.local/share/nvim/lazy/nvim-treesitter/parser 2>/dev/null | wc -l)" "$(words $(TS_PARSERS))"
	@printf '    mason:      %s\n' "$$(ls $(HOME)/.local/share/nvim/mason/bin 2>/dev/null | wc -l)"
	@printf '    vim:        %s\n' "$$(ls $(HOME)/.vim/plugged 2>/dev/null | wc -l)"
	@echo "==> fonts"
	@printf '    nerd faces: %s\n' "$$(fc-list 2>/dev/null | grep -ci jetbrains)"

clean: ## Remove generated plugin dirs (keeps local.zsh and .gitconfig.local)
	rm -rf $(DOTFILES)/.config/zsh/plugins $(DOTFILES)/.config/tmux/plugins
	rm -rf $(HOME)/.local/share/nvim $(HOME)/.local/state/nvim $(HOME)/.cache/nvim
	rm -rf $(HOME)/.vim/plugged $(HOME)/.vim/autoload
