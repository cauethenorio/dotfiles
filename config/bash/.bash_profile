# use sublime-text as default editor

export EDITOR='subl --new-window --wait'
export VISUAL=$EDITOR


# locale

export LC_LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8


# gpg

export GPG_TTY=$(tty)


# set PATH, MANPATH, etc., for Homebrew

[ -f /opt/homebrew/bin/brew ] && eval $(/opt/homebrew/bin/brew shellenv)
[ -f /usr/local/bin/brew ] && eval $(/usr/local/bin/brew shellenv)

brew_prefix=$(brew --prefix)
export PATH="$brew_prefix/sbin:$PATH"



# load autojump (if installed)

if [ -f "${brew_prefix}/share/autojump/autojump.bash" ]; then
  source "${brew_prefix}/share/autojump/autojump.bash"
fi


# enable asdf (languages versions manager) if installed

if [ -f "${brew_prefix}/opt/asdf/libexec/asdf.sh" ]; then
  source "${brew_prefix}/opt/asdf/libexec/asdf.sh"
fi


# golang

export GOPATH=~/dev/golang
if [ -d $GOPATH/bin ]; then
  export PATH=$PATH:$GOPATH/bin
fi


# rust

# Prepending path in case a system-installed rustc needs to be overridden
if [ -d ~/.cargo/bin ]; then
  export PATH=~/.cargo/bin:$PATH
fi


# pipx

if [ -d ~/.local/bin ]; then
  export PATH=$PATH:~/.local/bin
fi
