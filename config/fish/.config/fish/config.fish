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


# get brew prefix once

set brew_prefix (brew --prefix)


# homebrew installed executables

fish_add_path --prepend --path {$brew_prefix}/sbin


# load autojump (if installed)

[ -f {$brew_prefix}/share/autojump/autojump.fish ]; and source {$brew_prefix}/share/autojump/autojump.fish



# enable fish completion for homebrew installed formulas

for script in {$brew_prefix}/share/fish/vendor_completions.d/*.fish
	. $script
end


# enable asdf (languages versions manager) if installed

[ -f {$brew_prefix}/opt/asdf/libexec/asdf.fish ]; and source {$brew_prefix}/opt/asdf/libexec/asdf.fish


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
[ -d $GOPATH/bin ]; and fish_add_path --path $GOPATH/bin


# rust
# Prepending path in case a system-installed rustc needs to be overridden
[ -d ~/.cargo/bin ]; and fish_add_path --prepend --path ~/.cargo/bin


# poetry
set -gx PATH $PATH ~/.poetry/bin

[ -f (brew --prefix)/share/fish/vendor_completions.d/poetry.fish ]; and source (brew --prefix)/share/fish/vendor_completions.d/poetry.fish


# kill adobe zombie processes
alias kill-adobe="ps aux|grep -v 'grep'| grep 'Adobe'|awk '{ print  $2 }'|xargs kill -9"
