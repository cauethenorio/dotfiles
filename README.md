# .files

These are my dotfiles for macOS systems.
Take anything you want, but at your own risk.

## Highlights

- Minimal efforts to install everything, using a [Makefile](./Makefile)
- Mostly based around Homebrew, Caskroom and Bash
- Updated macOS defaults
- Well-organized and easy to customize
- Supports both Apple Silicon (M1) and Intel chips
- Tested on Ventura 13.1

## Packages Overview

- 🐠 [Fish Shell](https://fishshell.com/)
  - Default shell with sane defaults ([fish.config](./config/fish/.config/fish/config.fish)) 🚀
  - Installed [Oh-my-fish framework](https://github.com/oh-my-fish/oh-my-fish)
  - Installed [bobthefish theme](https://github.com/oh-my-fish/theme-bobthefish)
- 🐍 [Python](https://www.python.org/)
  - Latest three major versions
  - [Poetry](https://python-poetry.org/) dependency manager, managed by [asdf](https://asdf-vm.com/)
  - [Pipx](https://github.com/pypa/pipx) (packages: [pipx-libs.txt](./install/pipx-libs.txt))
- 🦏 Latest two [Node.js](https://nodejs.org/en/) LTS versions, managed by [asdf](https://asdf-vm.com/)
- 🤘 Latest [Rust](https://www.rust-lang.org/) and [Golang](https://go.dev/), managed by Homebrew
- 🍺 [Homebrew](https://brew.sh) (packages: [Brewfile](./install/Brewfile))
- 📱 [homebrew-cask](https://github.com/Homebrew/homebrew-cask) (packages: [Caskfile](./install/Caskfile))
- 🧩 Latest Git, GNU coreutils, curl

## Installation

On a sparkling fresh installation of macOS:

```bash
sudo softwareupdate -i -a
xcode-select --install
```

The Xcode Command Line Tools includes `git` and `make` (not available on stock macOS). Now there are two options:

1. Install this repo with `curl` available:

```bash
curl -fsSL http://localhost:8000/dotfiles/remote-install.sh | bash
```

This will clone this repo to `~/dev/dotfiles`.

Use the [Makefile](./Makefile) to install everything [listed above](#packages-overview) with a single command as:
```
cd ~/dev/dotfiles
make install
```

Or choose what to install:
```bash
cd ~/dev/dotfiles
make

make list           list all available commands
make install        install everything
make core-macos     install core tools as brew, git and fish shell
make brew           install homebrew
make git            install git
make fish           install fish shell, oh-my-fish framework and bobthefish theme
make stow-macos     install REMOVE-ME
make asdf           install asdf
make python         install three latest python versions
make node           install two latest LTS node versions
make rust           install rust
make packages       install brew, cask, rust and pipx packages
make brew-packages  install brew packages
make cask-apps      install cask apps
make rust-packages  install rust packages
make pipx-packages  install python pipx packages
```


## Credits

Many thanks to the [webpro dotfiles](https://github.com/webpro/dotfiles), used as base for this repo.
