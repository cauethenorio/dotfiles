# no greeting message, thank you
set fish_greeting


# bobthefish theme options
# https://github.com/oh-my-fish/theme-bobthefish

set default_user caue
set theme_date_format "+%F %T"
set theme_display_git_untracked no
set theme_display_ruby no
set theme_show_exit_status yes
set theme_display_vi no
set theme_display_node yes
set theme_display_jobs_verbose yes


# use sublime-text as default editor

set -x EDITOR 'subl --new-window --wait'
set -x VISUAL $EDITOR


# locale

set -x LC_LANG en_US.UTF-8
set -x LC_CTYPE en_US.UTF-8
set -x LC_ALL en_US.UTF-8


# gpg

set -x GPG_TTY (tty)


# set PATH, MANPATH, etc., for Homebrew

[ -f /opt/homebrew/bin/brew ]; and eval (/opt/homebrew/bin/brew shellenv)
[ -f /usr/local/bin/brew ]; and eval (/usr/local/bin/brew shellenv)

set brew_prefix (brew --prefix)
fish_add_path --prepend --path {$brew_prefix}/sbin


# load autojump (if installed)

[ -f {$brew_prefix}/share/autojump/autojump.fish ]; and source {$brew_prefix}/share/autojump/autojump.fish



# enable fish completion for homebrew installed formulas

for script in {$brew_prefix}/share/fish/vendor_completions.d/*.fish
  # avoid running docker-compose completion file when it's not available (i.e. docker wasn't executed yet)
  if not string match -q -r "docker-compose" "$script"; or which -s "docker-compose"
    . $script
  end
end


# enable rtx (languages versions manager) if installed

if type -q rtx
    rtx activate fish | source
end


# android

if [ -d ~/dev/android-sdk ]
  set -gx ANDROID_HOME ~/dev/android-sdk
  set -gx PATH $PATH $ANDROID_HOME/emulator
  set -gx PATH $PATH $ANDROID_HOME/tools
  set -gx PATH $PATH $ANDROID_HOME/tools/bin
  set -gx PATH $PATH $ANDROID_HOME/platform-tools
end


# golang

set -x GOPATH ~/dev/golang
fish_add_path --path $GOPATH/bin


# rust

# Prepending path in case a system-installed rustc needs to be overridden
fish_add_path --prepend --path ~/.cargo/bin


# pipx

fish_add_path --path ~/.local/bin


# starship prompt

which -s starship; and starship init fish | source
