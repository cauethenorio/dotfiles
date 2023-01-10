# .files

These are my dotfiles for macOS systems.
Take anything you want, but at your own risk.

## Highlights

- Minimal efforts to install everything, using a [Makefile](./Makefile)
- Mostly based around Homebrew, Caskroom and Bash
- Updated macOS defaults
- Well-organized and easy to customize
- Supports both Apple Silicon (M1) and Intel chips

## Packages Overview

- 🐠 [Fish Shell](https://fishshell.com/)
  - Is set as default shell with sane defaults ([fish.config](./config/fish/.config/fish/config.fish)) 🚀
  - Installed [Oh-my-fish framework](https://github.com/oh-my-fish/oh-my-fish)
  - Installed [bobthefish theme](https://github.com/oh-my-fish/theme-bobthefish)
- 🐍 Python
  - Latest three major [Python](https://www.python.org/) versions
  - [Poetry](https://python-poetry.org/) dependency manager, managed by [asdf](https://asdf-vm.com/)
  - [Pipx](https://github.com/pypa/pipx) (packages: [pipx-libs.txt](./install/pipx-libs.txt))
- 🦏 Latest two latest LTS [node](https://nodejs.org/en/) versions, managed by [asdf](https://asdf-vm.com/)
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

This will clone or download, this repo to `~/.dotfiles` depending on the availability of `git`, `curl` or `wget`.

1. Alternatively, clone manually into the desired location:

```bash
git clone https://github.com/webpro/dotfiles.git ~/.dotfiles
```

Use the [Makefile](./Makefile) to install everything [listed above](#package-overview), and symlink [runcom](./runcom)
and [config](./config) (using [stow](https://www.gnu.org/software/stow/)):

```bash
cd ~/.dotfiles
make
```


## Post-Installation

- `dot dock` (set [Dock items](./macos/dock.sh))
- `dot macos` (set [macOS defaults](./macos/defaults.sh))


## Customize

To customize the dotfiles to your likings, fork it and make sure to modify the locations above to your fork.

## Credits

Many thanks to the [webpro dotfiles](https://github.com/webpro/dotfiles), used as base for this repo.
