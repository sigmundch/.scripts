# Usage: load .bashrc, define ahead: HOME, MY_MACHINE, DART_EDITOR_HOME

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

SCRIPT_DIR=$(dirname ${BASH_SOURCE[0]})

# don't put duplicate lines in the history
export HISTCONTROL=ignoredups
# ... and ignore same sucessive entries
export HISTCONTROL=ignoreboth

# update the values of LINES and COLUMNS after each command, if needed
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

export TERM='xterm-256color'

function long_prompt_command {
  local red_bold="[01;31m"
  local none="[0m"
  local green="[0;32m"
  echo -en "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"
  echo -en "$red_bold|--[$green$(formatted_date)$none ";
  show_git_branch;
  show_and_update_client;
  echo -e "$red_bold]--|$none"
}

function show_and_update_client {
  echo -en `pwd`;
}

function formatted_date {
  date "+%H:%M:%S"
}

function show_git_branch {
  local cyan="[36m"
  local none="[0m"
  local head_file="$(git rev-parse --show-cdup 2>/dev/null).git/HEAD"
  if [ -f $head_file ]; then
    (cat $head_file | sed -e "s,.*heads/\(.*\), $cyan(\1)$none," |
      xargs echo -en)
  fi
}

function von {
  PROMPT_COMMAND='long_prompt_command'
}

function voff {
  PROMPT_COMMAND='echo -en "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"'
}

function named_prompt {
  PS1="\[\033[01;31m\]|--[\[\033[0m\]$1\[\033[31;1m\]]\[\033[0m\] "
}

PS1='\[\033[01;31m\]`if [ \u != $MY_USER ]; then echo "\u "; fi``if [ \h != $MY_MACHINE ]; then echo "[@\h]"; else echo "|"; fi`\[\033[0m\] '

von;

if [ -f $SCRIPT_DIR/bin/bash_completion ]; then
  . $SCRIPT_DIR/bin/bash_completion
fi

if [ -f $SCRIPT_DIR/bin/git_completion.sh ]; then
  . $SCRIPT_DIR/bin/git_completion.sh
fi
export EDITOR='vim'


# ls with colors
alias ls='ls --color=auto'

# Dart
export DART_DRT_HOME=$DART_EDITOR_HOME/chromium/
export MY_DART_SDK=$DART_EDITOR_HOME/dart-sdk
export PATH=$SCRIPT_DIR/bin:~/bin/depot_tools:$PATH:$MY_DART_SDK/bin:$DART_DRT_HOME:/usr/local/lib/node_modules/
alias dartium=$DART_EDITOR_HOME/chromium/chrome
alias editor="PATH=$JAVA_HOME/bin:$PATH $DART_EDITOR_HOME/DartEditor"

source $SCRIPT_DIR/bin/load_all.sh

function fix_bashrc {
     vim ~/.bashrc;
     source ~/.bashrc;
     echo "~/.bashrc updated";
}

function reload_bashrc {
     source ~/.bashrc;
}

export GREP_OPTIONS="--color=auto"

alias v='gvim --remote-silent'

# enable us_intl keyboard and toggling with alt+shift:
# setxkbmap -option grp:switch,grp:shifts_toggle us,us_intl
# see file /usr/share/X11/xkb/symbols/group for more group descriptions...
