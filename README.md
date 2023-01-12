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

- 🐠 [Fish Shell](https://fishshell.com/)
  - Configured with [sane defaults](./config/fish/.config/fish/config.fish) and set as default shell
  - [Oh-my-fish framework](https://github.com/oh-my-fish/oh-my-fish)
  - [bobthefish theme](https://github.com/oh-my-fish/theme-bobthefish)
- [asdf](https://asdf-vm.com/) language/tool version manager
- 🐍 [Python](https://www.python.org/)
  - The three latest versions of Python, managed by [asdf](https://asdf-vm.com/)
  - [Pipx](https://github.com/pypa/pipx) package runner (with some packages: [pipx-libs.txt](./install/pipx-libs.txt))
  - [Poetry](https://python-poetry.org/) dependency and package manager, managed by [Pipx](https://github.com/pypa/pipx) due [this issue](https://github.com/python-poetry/install.python-poetry.org/issues/24)
- 🦏 Latest two [Node.js](https://nodejs.org/en/) LTS versions, managed by [asdf](https://asdf-vm.com/)
- 🤘 Latest [Rust](https://www.rust-lang.org/), managed by [Homebrew](https://brew.sh) (packages: [Rustfile](./install/Rustfile))
- 🦄 Latest [Golang](https://go.dev/), managed by [Homebrew](https://brew.sh)
- 🍺 [Homebrew](https://brew.sh) (packages: [Brewfile](./install/Brewfile))
- 📱 [homebrew-cask](https://github.com/Homebrew/homebrew-cask) (packages: [Caskfile](./install/Caskfile))
- 🧩 Latest Git, GNU coreutils, curl

## Installation

On a sparkling fresh installation of macOS:

```bash
sudo softwareupdate -i -a
xcode-select --install
```

The Xcode Command Line Tools includes `git` and `make` (not available on stock macOS).

1. Install the repo with:

```bash
curl -fsSL https://raw.githubusercontent.com/cauethenorio/dotfiles/main/remote-install.sh | bash
```

Now you can chdir to the repo dir:
```bash
cd ~/dev/dotfiles
```

And Use the [Makefile](./Makefile) to install everything [listed above](#packages-overview) with:
```bash
make install
```

Or choose what to install by running:
```bash
make
```

It will list all available options:
```
make list           list all available commands
make install        install everything
make core-macos     install core tools as brew, git and fish shell
make brew           install homebrew
make git            install git
make fish           install fish shell, oh-my-fish framework and bobthefish theme
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
