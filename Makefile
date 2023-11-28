SHELL = /bin/bash
OS := $(shell bin/is-supported bin/is-macos macos linux)
DOTFILES_DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
HOMEBREW_PREFIX := $(shell bin/is-supported bin/is-arm64 /opt/homebrew /usr/local)
export PATH := $(HOMEBREW_PREFIX)/bin:$(DOTFILES_DIR)/bin:$(PATH)
export XDG_CONFIG_HOME = $(HOME)/.config
export ACCEPT_EULA=Y

.PHONY: test rust


.sudo:
	@sudo -v
	@# background job to keep the sudo command active in the background avoiding additional prompts
	@while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &


.stow: brew
	@log section "Ensuring stow is installed..."
	@which -s stow || brew install stow


#: list all available commands
list:
	@grep -B1 -E "^[a-zA-Z0-9_-]+\:([^\=]|$$)" Makefile \
     | grep -v -- -- \
     | sed 'N;s/\n/###/' \
     | sed -n 's/^#: \(.*\)###\(.*\):.*/make \2###\1/p' \
     | column -t  -s '###'


#: install everything
install: .sudo core-macos python node rust packages clean-dock iterm2


#: install core tools as brew, git and fish shell
core-macos: brew git fish starship-prompt bash-config


#: install homebrew
brew:
	@log section "Ensuring brew is installed..."
	@which -s brew || curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh | bash


#: install git
git: brew .stow
	@log section "Ensuring git is installed..."
	@link-config "git"
	@which -s git || brew install git git-extras


#: install fish shell, oh-my-fish framework and bobthefish theme
fish: FISH_BIN=$(HOMEBREW_PREFIX)/bin/fish
fish: SHELLS=/etc/shells
fish: OMF_INSTALL_FILE := $(shell mktemp -t omf-install)
fish: OMF_CONFIG_DIR=$(XDG_CONFIG_HOME)/omf
fish: .sudo git brew .stow
	@log section "Installing fish shell..."
	@log "Restoring fish shell configuration files..."
	@link-config "fish"

	@log "Ensuring fish shell is installed..."
	@which -s fish || brew install fish

	@log "Ensuring fish shell is available in shells list..."
	@grep -qxF "$(FISH_BIN)" "$(SHELLS)" || echo "$(FISH_BIN)" | sudo tee -a "$(SHELLS)" > /dev/null

	@log "Ensuring fish is the default shell..."
	@if ! dscl . -read ~ UserShell | grep -q $(FISH_BIN); then \
  	chsh -s $(FISH_BIN); \
	fi

	@log "Ensuring the oh-my-fish framework is installed..."
	@# https://github.com/oh-my-fish/oh-my-fish
	@link-config "omf"

	@if ! fish -c "omf" >/dev/null 2>&1; then \
		log "Installing oh-my-fish framework..."; \
		curl -fsSL https://get.oh-my.fish -o $(OMF_INSTALL_FILE); \
		fish $(OMF_INSTALL_FILE) --noninteractive --yes; \
	fi


starship-prompt: fish
	@log section "Installing starship shell prompt..."
	@link-config "starship"
	@which -s starship || brew install starship


#: Configure the bash shell with the paths for the installed tools
bash-config:
	@log section "Setting up bash..."
	@link-config "bash"

#: install rtx (replace asdf)
rtx: python-deps
	@log section "Installing rtx..."
	@which -s rtx || brew install jdx/tap/rtx
	@link-config "rtx"
	@rtx install

#: install python build dependencies
python-deps: brew
	@log "Ensuring python build dependencies are installed..."
	@# obtained from Homebrew's python formulas
	@PY_DEPS=("mpdecimal" "openssl@1.1" "sqlite" "xz" "gdbm" "readline"); \
	for DEP in $${PY_DEPS[@]}; do \
	  is-brew-formula-installed "$$DEP" "$(HOMEBREW_PREFIX)" || brew install "$$DEP"; \
	done

python-pip: rtx
	@log "Installing pipx..."
	@source <(echo "$$($$(brew --prefix rtx)/bin/rtx activate bash)") && (which -s pipx || pip install pipx)

python-poetry: rtx
	@log "Installing python poetry..."
	@source <(echo "$$($$(brew --prefix rtx)/bin/rtx activate bash)") && PATH=$$PATH:~/.local/bin pipx install poetry;
	@mkdir -p $(XDG_CONFIG_HOME)/fish/completions/
	@PATH=$$PATH:~/.local/bin poetry completions fish > $(XDG_CONFIG_HOME)/fish/completions/poetry.fish

#: install python, pipx and poetry
python: python-deps rtx python-pip python-poetry


#: install node
node: rtx


#: install rust
rust: brew
	@log section "Installing rust..."
	@which -s rustup-init || brew install rustup
	@which -s rustup-init && rustup-init --no-modify-path -y


#: install and configure iterm2
iterm2: brew
	@log section "Installing and setting up iTerm2..."
	@is-brew-formula-installed "iterm2" "$(HOMEBREW_PREFIX)" || brew install "iterm2"
	@link-config "iterm2"
	@defaults write com.googlecode.iterm2 "LoadPrefsFromCustomFolder" -bool true
	@defaults write com.googlecode.iterm2 "PrefsCustomFolder" -string "$(XDG_CONFIG_HOME)/iterm2"
	@open -a "/Applications/iTerm.app"
	@osascript -e 'tell application "System Events" to make login item at end with properties {name: "iTerm2", path:"/Applications/iTerm.app", hidden:false}'


clean-dock:
	@log section "Cleaning Dock..."
	@./macos/clean-dock.sh

#: install brew, cask, rust and pipx packages
packages: brew-packages cask-apps rust-packages pipx-packages


#: install brew packages
brew-packages: brew
	@log section "Installing all brew formulas from the Brewfile..."
	@brew bundle --no-lock --file=$(DOTFILES_DIR)/install/Brewfile || true


#: install cask apps
cask-apps: brew
	@log section "Installing apps from the Caskfile..."
	@brew bundle --file=$(DOTFILES_DIR)/install/Caskfile || true
	@xattr -d -r com.apple.quarantine ~/Library/QuickLook


#: install rust packages
rust-packages: rust
	~/.cargo/bin/cargo install $$(cat install/Rustfile)


#: install python pipx packages
pipx-packages: python
	@source <(echo "$$($$(brew --prefix rtx)/bin/rtx activate bash)"); \
	cat ./install/pipx-libs.txt | PATH=$$PATH:~/.local/bin xargs -n1 pipx install;


#: create SSH key if there is none
ssh-key:
	@log section "Ensuring a SSH key exists..."
	@if ! ls ~/.ssh/id_* 1> /dev/null 2>&1; then \
		log section "SSH key not found. Creating..."; \
		ssh-keygen -t ed25519 -C "$$(whoami)@$$(hostname)" -f ~/.ssh/id_ed25519; \
		ssh-add --apple-use-keychain; \
	fi;
