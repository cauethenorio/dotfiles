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

## What you'll get:

- 💬 [iTerm2](https://iterm2.com/) terminal emulator configured with hotkey (^`) to toggle visibility (quake mode)
- 🐠 [Fish Shell](https://fishshell.com/)
  - Configured with [sane defaults](./config/fish/.config/fish/config.fish) and set as default shell
  - [Oh-my-fish framework](https://github.com/oh-my-fish/oh-my-fish)
  - [bobthefish theme](https://github.com/oh-my-fish/theme-bobthefish)
- [asdf](https://asdf-vm.com/) language/tool version manager
- 🐍 [Python](https://www.python.org/)
  - The three latest versions of Python, managed by [asdf](https://asdf-vm.com/)
  - [Pipx](https://github.com/pypa/pipx) package runner (with some packages: [pipx-libs.txt](./install/pipx-libs.txt))
  - [Poetry](https://python-poetry.org/) dependency and package manager, managed by [Pipx](https://github.com/pypa/pipx) due [this issue](https://github.com/python-poetry/install.python-poetry.org/issues/24)
- 🦏 The latest two [Node.js](https://nodejs.org/en/) LTS versions, managed by [asdf](https://asdf-vm.com/)
- 🤘 The latest [Rust](https://www.rust-lang.org/), managed by [Homebrew](https://brew.sh) (packages: [Rustfile](./install/Rustfile))
- 🦄 The latest [Golang](https://go.dev/), managed by [Homebrew](https://brew.sh)
- 🍺 [Homebrew](https://brew.sh) (packages: [Brewfile](./install/Brewfile))
- 📱 [homebrew-cask](https://github.com/Homebrew/homebrew-cask) (packages: [Caskfile](./install/Caskfile))
- 🔨 Bash shell [configured with the paths for the installed tools](./config/bash/.bash_profile), required by tools like PyCharm
- 🧩 Latest Git, GNU coreutils, curl

## Installation

1. Install the repo with:

    ```bash
    curl -fsSL https://raw.githubusercontent.com/cauethenorio/dotfiles/main/remote-install.sh | bash
    ```

2. Now you can chdir to the repo dir and choose what to install of all [listed above](#what-youll-get-) by using the `make` command:
    ```bash
    cd ~/dev/dotfiles
    make

    make list           list all available commands
    make install        install everything
    make core-macos     install core tools as brew, git and fish shell
    make brew           install homebrew
    make git            install git
    make fish           install fish shell, oh-my-fish framework and bobthefish theme
    make bash-config    Configure the bash shell with the paths for the installed tools
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

### TLDR: Use `make install` to install everything

## TODO

- Setup dock


## Credits

Many thanks to the [webpro dotfiles](https://github.com/webpro/dotfiles), used as base for this repo.
