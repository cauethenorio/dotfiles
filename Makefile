SHELL = /bin/bash
OS := $(shell bin/is-supported bin/is-macos macos linux)
DOTFILES_DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
HOMEBREW_PREFIX := $(shell bin/is-supported bin/is-arm64 /opt/homebrew /usr/local)
PATH := $(HOMEBREW_PREFIX)/bin:$(DOTFILES_DIR)/bin:$(PATH)
export XDG_CONFIG_HOME = $(HOME)/.config
export ACCEPT_EULA=Y

.PHONY: test


.sudo:
	@sudo -v
	@# background job to keep the sudo command active in the background avoiding additional prompts
	@while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &


.stow: brew
	@log section "Ensuring stow is installed..."
	@is-executable stow || brew install stow


#: list all available commands
list:
	@grep -B1 -E "^[a-zA-Z0-9_-]+\:([^\=]|$$)" Makefile \
     | grep -v -- -- \
     | sed 'N;s/\n/###/' \
     | sed -n 's/^#: \(.*\)###\(.*\):.*/make \2###\1/p' \
     | column -t  -s '###'


#: install everything
install: .sudo core-macos python node rust packages


#: install core tools as brew, git and fish shell
core-macos: brew git fish


#: install homebrew
brew:
	@log section "Ensuring brew is installed..."
	@is-executable brew || curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh | bash


#: install git
git: brew .stow
	@log section "Ensuring git is installed..."
	@link-config "git"
	@is-executable git || brew install git git-extras


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
	@is-executable fish || brew install fish

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


#: install asdf
asdf:
	@log section "Installing asdf..."
	@is-executable asdf || brew install asdf


#: install three latest python versions
python: asdf
	@log section "Installing python runtimes..."
	@asdf plugin list | grep -q python || asdf plugin add python
	@PY_VERSIONS="$$(asdf list all python 3|grep -v dev| grep -v 'a' | sed 's/\.[0-9]*$$//' | uniq | tail -n3 | xargs)"; \
	log "Installing python versions $$PY_VERSIONS..."; \
	for PY_VERSION in $${PY_VERSIONS[@]}; do \
  	asdf install python latest:$$PY_VERSION; \
	done
	@LATEST_PY=$$(asdf list python| sort -V | tail -n1 | tr -d ' ' | tr -d '*'); \
		log "Python $$LATEST_PY set as global"; \
		asdf global python $$LATEST_PY;

	@log "Installing python poetry..."
	@asdf plugin list | grep -q poetry || @asdf plugin-add poetry https://github.com/asdf-community/asdf-poetry.git
	@asdf install poetry latest:
	@asdf global poetry $$(asdf list poetry | tail -n1 | tr -d  ' ' | tr -d '*')

	@log "Installing pipx..."
	@source $$(brew --prefix asdf)/libexec/asdf.sh && (is-executable pipx || pip install pipx);


#: install two latest LTS node versions
node: asdf
	@log section "Installing node runtimes..."
	@asdf plugin list | grep -q nodejs || asdf plugin add nodejs

	@NODE_VERSIONS="$$(asdf list all nodejs lts-| uniq | tail -n2 | xargs)"; \
	log "Installing Node.js versions $$PY_VERSIONS..."; \
	for NODE_VERSION in $${NODE_VERSIONS[@]}; do \
  	asdf install nodejs latest:$$NODE_VERSION; \
	done

	@LATEST_NODE=$$(asdf list nodejs| sort -V | tail -n1 | tr -d ' ' | tr -d '*'); \
		log "Node $$LATEST_NODE set as global"; \
		asdf global nodejs $$LATEST_NODE;


#: install rust
rust: brew
	@log section "Installing rust..."
	@brew install rustup
	@rustup-init --no-modify-path -y


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
	@source $$(brew --prefix asdf)/libexec/asdf.sh; \
	cat ./install/pipx-libs.txt | PATH=$$PATH:~/.local/bin xargs -n1 pipx install;
